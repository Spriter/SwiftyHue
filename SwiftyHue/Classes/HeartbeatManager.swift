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

public enum BridgeResourceType: String {
    case Lights, Groups, Scenes, Sensors, Rules, Config, Schedules
}

public protocol HeartbeatProcessor {
    
    func processJSON(json: JSON, forResourceType resourceType: BridgeResourceType)
}

public class HeartbeatManager {
    
    private let bridgeAccesssConfig: BridgeAccessConfig;
    private var localHeartbeatTimers = [BridgeResourceType: NSTimer]()
    private var localHeartbeatTimerIntervals = [BridgeResourceType: NSTimeInterval]()
    private var heartbeatProcessors: [HeartbeatProcessor];
    
    private var lastLocolConnectionNotificationPostTime: NSTimeInterval?
    private var lastNoLocolConnectionNotificationPostTime: NSTimeInterval?

    public init(bridgeAccesssConfig: BridgeAccessConfig, heartbeatProcessors: [HeartbeatProcessor]) {
        self.bridgeAccesssConfig = bridgeAccesssConfig
        self.heartbeatProcessors = heartbeatProcessors;
    }
    
    internal func setLocalHeartbeatInterval(interval: NSTimeInterval, forResourceType resourceType: BridgeResourceType) {
        
        localHeartbeatTimerIntervals[resourceType] = interval
    }
    
    public func removeLocalHeartbeatInterval(interval: Float, forResourceType resourceType: BridgeResourceType) {
        
        if let timer = localHeartbeatTimers.removeValueForKey(resourceType) {
            
            timer.invalidate()
        }
    }
    
    internal func startHeartbeat() {
       
        for (resourceType, timerInterval) in localHeartbeatTimerIntervals {
            
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
        
        let resourceType: BridgeResourceType = BridgeResourceType(rawValue: timer.userInfo! as! String)!
        
        Log.trace("Heartbeat Request", "http://\(bridgeAccesssConfig.ipAddress)/api/\(bridgeAccesssConfig.username)/\(resourceType.rawValue.lowercaseString)")
        
        Alamofire.request(.GET, "http://\(bridgeAccesssConfig.ipAddress)/api/\(bridgeAccesssConfig.username)/\(resourceType.rawValue.lowercaseString)", parameters: nil)
            .responseJSON { response in
                
                switch response.result {
                case .Success:
                    
                    self.handleSuccessResponseResult(response.result, resourceType: resourceType)
                    self.notifyAboutLocalConnection()
                    
                case .Failure(let error):
                    
                    self.notifyAboutNoLocalConnection()
                    Log.error(error)
                }
        }
    
    }
    
    // MARK: Timer Action Response Handling
    
    private func handleSuccessResponseResult(result: Result<AnyObject, NSError>, resourceType: BridgeResourceType) {
        
        Log.trace("Heartbeat Response for Resource Type: \(resourceType.rawValue.lowercaseString): ", result.value)
        
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
        
        if lastLocolConnectionNotificationPostTime == nil || NSDate().timeIntervalSince1970 - lastLocolConnectionNotificationPostTime! > 10 {
            
            let notification = BridgeHeartbeatConnectionStatusNotification(rawValue: "localConnection")!
            Log.info("Post Notification:", notification.rawValue)
            NSNotificationCenter.defaultCenter().postNotificationName(notification.rawValue, object: nil)
            
            self.lastLocolConnectionNotificationPostTime = NSDate().timeIntervalSince1970;
        }
    }
    
    private func notifyAboutNoLocalConnection() {
        
        if lastNoLocolConnectionNotificationPostTime == nil || NSDate().timeIntervalSince1970 - lastNoLocolConnectionNotificationPostTime! > 10 {
            
            let notification = BridgeHeartbeatConnectionStatusNotification(rawValue: "nolocalConnection")!
            Log.info("Post Notification:", notification.rawValue)
            NSNotificationCenter.defaultCenter().postNotificationName(notification.rawValue, object: nil)
            
            self.lastLocolConnectionNotificationPostTime = NSDate().timeIntervalSince1970;
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
            
            Log.trace("Post Notification:", notification.rawValue)
            NSNotificationCenter.defaultCenter().postNotificationName(notification.rawValue, object: nil)
        }
    }
}