//
//  BeatManager.swift
//  Pods
//
//  Created by Marcel Dittmann on 23.04.16.
//
//

import Foundation
import Gloss
import Alamofire

public enum BridgeHeartbeatConnectionStatusNotification: String {
    
    case localConnection, notAuthenticated, nolocalConnection
}

public enum HeartbeatBridgeResourceType: String {
    case lights, groups, scenes, sensors, rules, config, schedules
}

public protocol HeartbeatProcessor {
    
    func processJSON(json: JSON, forResourceType resourceType: HeartbeatBridgeResourceType)
}

public class HeartbeatManager {
    
    private let bridgeAccesssConfig: BridgeAccessConfig;
    private var localHeartbeatTimers = [HeartbeatBridgeResourceType: NSTimer]()
    private var localHeartbeatTimerIntervals = [HeartbeatBridgeResourceType: NSTimeInterval]()
    private var heartbeatProcessors: [HeartbeatProcessor];
    
    private var lastLocalConnectionNotificationPostTime: NSTimeInterval?
    private var lastNoLocalConnectionNotificationPostTime: NSTimeInterval?

    public init(bridgeAccesssConfig: BridgeAccessConfig, heartbeatProcessors: [HeartbeatProcessor]) {
        self.bridgeAccesssConfig = bridgeAccesssConfig
        self.heartbeatProcessors = heartbeatProcessors;
    }
    
    internal func setLocalHeartbeatInterval(interval: NSTimeInterval, forResourceType resourceType: HeartbeatBridgeResourceType) {
        
        localHeartbeatTimerIntervals[resourceType] = interval
    }
    
    public func removeLocalHeartbeatInterval(interval: Float, forResourceType resourceType: HeartbeatBridgeResourceType) {
        
        if let timer = localHeartbeatTimers.removeValueForKey(resourceType) {
            
            timer.invalidate()
        }
    }
    
    internal func startHeartbeat() {
       
        for (resourceType, timerInterval) in localHeartbeatTimerIntervals {
            
            // Do Initial Request
            doRequestForResourceType(resourceType)
            
            // Create Timer
            let timer = NSTimer(timeInterval: timerInterval, target: self, selector: #selector(HeartbeatManager.timerAction), userInfo: resourceType.rawValue, repeats: true);
            
            // Store timer
            localHeartbeatTimers[resourceType] = timer;
            
            // Add Timer to RunLoop
            NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        }
    }
    
    internal func stopHeartbeat() {
        
        for (resourceType, timer) in localHeartbeatTimers {
            
            timer.invalidate()
            localHeartbeatTimers.removeValueForKey(resourceType)
        }
    }
    
    @objc func timerAction(timer: NSTimer) {
        
        let resourceType: HeartbeatBridgeResourceType = HeartbeatBridgeResourceType(rawValue: timer.userInfo! as! String)!
        doRequestForResourceType(resourceType)
    }
    
    private func doRequestForResourceType(resourceType: HeartbeatBridgeResourceType) {
        
        Log.trace("Heartbeat Request", "http://\(bridgeAccesssConfig.ipAddress)/api/\(bridgeAccesssConfig.username)/\(resourceType.rawValue.lowercaseString)")
        
        Alamofire.request(.GET, "http://\(bridgeAccesssConfig.ipAddress)/api/\(bridgeAccesssConfig.username)/\(resourceType.rawValue.lowercaseString)", parameters: nil)
            .responseJSON { response in
                
                switch response.result {
                case .Success:
                    
                    self.handleSuccessResponseResult(response.result, resourceType: resourceType)
                    self.notifyAboutLocalConnection()
                    
                case .Failure(let error):
                    
                    self.notifyAboutNoLocalConnection()
                    Log.trace("Heartbeat Request Error: ", error)
                }
        }
    }
    
    // MARK: Timer Action Response Handling
    
    private func handleSuccessResponseResult(result: Result<AnyObject, NSError>, resourceType: HeartbeatBridgeResourceType) {
        
        Log.trace("Heartbeat Response for Resource Type \(resourceType.rawValue.lowercaseString) received")
        //Log.trace("Heartbeat Response: \(resourceType.rawValue.lowercaseString): ", result.value)
        
        if let resultValueJSON = result.value as? JSON {
            
            for heartbeatProcessor in self.heartbeatProcessors {
                heartbeatProcessor.processJSON(resultValueJSON, forResourceType: resourceType)
            }
            
        } else if let resultValueJSONArray = result.value as? [JSON] {
            
            self.handleErrors(resultValueJSONArray)
        }
    }
    
    private func handleErrors(jsonErrorArray: [JSON]) {
        
        for jsonError in jsonErrorArray {
            
            Log.info("Hearbeat received Error Result", (json: jsonError))
            var error = Error(json: jsonError)
            if let error = error {
                self.notifyAboutError(error)
            }
        }
    }
    
    // MARK: Notification
    
    private func notifyAboutLocalConnection() {
        
        if lastLocalConnectionNotificationPostTime == nil || NSDate().timeIntervalSince1970 - lastLocalConnectionNotificationPostTime! > 10 {
            
            let notification = BridgeHeartbeatConnectionStatusNotification(rawValue: "localConnection")!
            Log.info("Post Notification:", notification.rawValue)
            NSNotificationCenter.defaultCenter().postNotificationName(notification.rawValue, object: nil)
            
            self.lastLocalConnectionNotificationPostTime = NSDate().timeIntervalSince1970;
            
            // Make sure we instant notify about losing connection
            self.lastNoLocalConnectionNotificationPostTime = nil;
        }
    }
    
    private func notifyAboutNoLocalConnection() {
        
        if lastNoLocalConnectionNotificationPostTime == nil || NSDate().timeIntervalSince1970 - lastNoLocalConnectionNotificationPostTime! > 10 {
            
            let notification = BridgeHeartbeatConnectionStatusNotification(rawValue: "nolocalConnection")!
            Log.info("Post Notification:", notification.rawValue)
            NSNotificationCenter.defaultCenter().postNotificationName(notification.rawValue, object: nil)
            
            self.lastNoLocalConnectionNotificationPostTime = NSDate().timeIntervalSince1970;
            
            // Make sure we instant notify about getting connection
            self.lastLocalConnectionNotificationPostTime = nil;
        }
    }
    
    private func notifyAboutError(error: Error) {
        
        var notification: BridgeHeartbeatConnectionStatusNotification?;
        
        switch(error.type) {
            
        case .unauthorizedUser:
            notification = BridgeHeartbeatConnectionStatusNotification(rawValue: "notAuthenticated")
        default:
            break;
        }
        
        if let notification = notification {
            
            Log.trace("Post Notification: ", notification.rawValue)
            NSNotificationCenter.defaultCenter().postNotificationName(notification.rawValue, object: nil)
        }
    }
}