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
    
    func processJSON(_ json: JSON, forResourceType resourceType: HeartbeatBridgeResourceType)
}

public class HeartbeatManager {
    
    private let bridgeAccesssConfig: BridgeAccessConfig;
    private var localHeartbeatTimers = [HeartbeatBridgeResourceType: Timer]()
    private var localHeartbeatTimerIntervals = [HeartbeatBridgeResourceType: TimeInterval]()
    private var heartbeatProcessors: [HeartbeatProcessor];
    
    private var lastLocalConnectionNotificationPostTime: TimeInterval?
    private var lastNoLocalConnectionNotificationPostTime: TimeInterval?

    public init(bridgeAccesssConfig: BridgeAccessConfig, heartbeatProcessors: [HeartbeatProcessor]) {
        self.bridgeAccesssConfig = bridgeAccesssConfig
        self.heartbeatProcessors = heartbeatProcessors;
    }
    
    internal func setLocalHeartbeatInterval(_ interval: TimeInterval, forResourceType resourceType: HeartbeatBridgeResourceType) {
        
        localHeartbeatTimerIntervals[resourceType] = interval
    }
    
    internal func removeLocalHeartbeat(forResourceType resourceType: HeartbeatBridgeResourceType) {
        
        if let timer = localHeartbeatTimers.removeValue(forKey: resourceType) {
            
            timer.invalidate()
        }
    }
    
    internal func startHeartbeat() {
       
        for (resourceType, timerInterval) in localHeartbeatTimerIntervals {
            
            // Do Initial Request
            doRequestForResourceType(resourceType)
            
            // Create Timer
            let timer = Timer(timeInterval: timerInterval, target: self, selector: #selector(HeartbeatManager.timerAction), userInfo: resourceType.rawValue, repeats: true);
            
            // Store timer
            localHeartbeatTimers[resourceType] = timer;
            
            // Add Timer to RunLoop
            RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
        }
    }
    
    internal func stopHeartbeat() {
        
        for (resourceType, timer) in localHeartbeatTimers {
            
            timer.invalidate()
            localHeartbeatTimers.removeValue(forKey: resourceType)
        }
    }
    
    @objc func timerAction(_ timer: Timer) {
        
        let resourceType: HeartbeatBridgeResourceType = HeartbeatBridgeResourceType(rawValue: timer.userInfo! as! String)!
        doRequestForResourceType(resourceType)
    }
    
    private func doRequestForResourceType(_ resourceType: HeartbeatBridgeResourceType) {

        let url = "http://\(bridgeAccesssConfig.ipAddress)/api/\(bridgeAccesssConfig.username)/\(resourceType.rawValue.lowercased())"

        Log.trace("Heartbeat Request", "\(url)")
        
        Alamofire.request(url)
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    
                    self.handleSuccessResponseResult(response.result, resourceType: resourceType)
                    self.notifyAboutLocalConnection()
                    
                case .failure(let error):
                    
                    self.notifyAboutNoLocalConnection()
                    Log.trace("Heartbeat Request Error: ", error)
                }
        }
    }
    
    // MARK: Timer Action Response Handling
    
    private func handleSuccessResponseResult(_ result: Result<Any>, resourceType: HeartbeatBridgeResourceType) {
        
        Log.trace("Heartbeat Response for Resource Type \(resourceType.rawValue.lowercased()) received")
        //Log.trace("Heartbeat Response: \(resourceType.rawValue.lowercaseString): ", result.value)
        
        if responseResultIsPhilipsAPIErrorType(result: result, resourceType: resourceType) {
            
            if let resultValueJSONArray = result.value as? [JSON] {
                
                self.handleErrors(resultValueJSONArray)
            }
            
        } else {
            
            if let resultValueJSON = result.value as? JSON {
                
                for heartbeatProcessor in self.heartbeatProcessors {
                    heartbeatProcessor.processJSON(resultValueJSON, forResourceType: resourceType)
                }
                
                self.notifyAboutLocalConnection()
                
            }
        }
        
    }
    
    private func responseResultIsPhilipsAPIErrorType(result: Result<Any>, resourceType: HeartbeatBridgeResourceType) -> Bool {
        
        switch resourceType {
            
        case .config:
            
            if let resultValueJSON = result.value as? JSON {
                
                return resultValueJSON.count <= 8 // HUE API gives always a respond for config request, but it only contains 8 Elements if no authorized user is used
            }
            
        default:
            
            return result.value as? [JSON] != nil // Errros are delivered as Array
        }
        
        return false
    }
    
    private func handleErrors(_ jsonErrorArray: [JSON]) {
        
        for jsonError in jsonErrorArray {
            
            Log.info("Hearbeat received Error Result", (json: jsonError))
            let error = HueError(json: jsonError)
            if let error = error {
                self.notifyAboutError(error)
            }
        }
    }
    
    // MARK: Notification
    
    private func notifyAboutLocalConnection() {
        
        if lastLocalConnectionNotificationPostTime == nil || Date().timeIntervalSince1970 - lastLocalConnectionNotificationPostTime! > 10 {
            
            let notification = BridgeHeartbeatConnectionStatusNotification(rawValue: "localConnection")!
            Log.info("Post Notification:", notification.rawValue)
            NotificationCenter.default.post(name: Notification.Name(rawValue: notification.rawValue), object: nil)
            
            self.lastLocalConnectionNotificationPostTime = Date().timeIntervalSince1970;
            
            // Make sure we instant notify about losing connection
            self.lastNoLocalConnectionNotificationPostTime = nil;
        }
    }
    
    private func notifyAboutNoLocalConnection() {
        
        if lastNoLocalConnectionNotificationPostTime == nil || Date().timeIntervalSince1970 - lastNoLocalConnectionNotificationPostTime! > 10 {
            
            let notification = BridgeHeartbeatConnectionStatusNotification(rawValue: "nolocalConnection")!
            Log.info("Post Notification:", notification.rawValue)
            NotificationCenter.default.post(name: Notification.Name(rawValue: notification.rawValue), object: nil)
            
            self.lastNoLocalConnectionNotificationPostTime = Date().timeIntervalSince1970;
            
            // Make sure we instant notify about getting connection
            self.lastLocalConnectionNotificationPostTime = nil;
        }
    }
    
    private func notifyAboutError(_ error: HueError) {
        
        var notification: BridgeHeartbeatConnectionStatusNotification?;
        
        switch(error.type) {
            
        case .unauthorizedUser:
            notification = BridgeHeartbeatConnectionStatusNotification(rawValue: "notAuthenticated")
        default:
            break;
        }
        
        if let notification = notification {
            
            Log.trace("Post Notification: ", notification.rawValue)
            NotificationCenter.default.post(name: Notification.Name(rawValue: notification.rawValue), object: nil)
        }
    }
}
