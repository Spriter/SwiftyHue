//
//  BeatManager.swift
//  Pods
//
//  Created by Marcel Dittmann on 23.04.16.
//
//

import Foundation
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
            RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
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

        let url = "https://\(bridgeAccesssConfig.ipAddress)/api/\(bridgeAccesssConfig.username)/\(resourceType.rawValue.lowercased())"

        print("Heartbeat Request", "\(url)")
        
        HueNetwork.session.request(url).responseJSON { response in // method
            
            switch response.result {
            case .success(let value):
                
                self.handleSuccessResponseValue(value, resourceType: resourceType)
                self.notifyAboutLocalConnection()
                
            case .failure(let error):
                
                self.notifyAboutNoLocalConnection()
                print("Heartbeat Request Error: ", error)
            }
            
        }
    }
    
    // MARK: Timer Action Response Handling
    
    private func handleSuccessResponseValue(_ value: Any, resourceType: HeartbeatBridgeResourceType) {
        
        print("Heartbeat Response for Resource Type \(resourceType.rawValue.lowercased()) received")
        //Log.trace("Heartbeat Response: \(resourceType.rawValue.lowercaseString): ", value)
        
        if responseResultIsPhilipsAPIErrorType(value: value, resourceType: resourceType) {
            
            if let resultValueJSONArray = value as? [JSON] {
                
                self.handleErrors(resultValueJSONArray)
            }
            
        } else {
            
            if let resultValueJSON = value as? JSON {
                
                for heartbeatProcessor in self.heartbeatProcessors {
                    heartbeatProcessor.processJSON(resultValueJSON, forResourceType: resourceType)
                }
                
                self.notifyAboutLocalConnection()
                
            }
        }
        
    }
    
    private func responseResultIsPhilipsAPIErrorType(value: Any, resourceType: HeartbeatBridgeResourceType) -> Bool {
        
        switch resourceType {
            
        case .config:
            
            if let resultValueJSON = value as? JSON {
                
                return resultValueJSON.count <= 8 // HUE API gives always a respond for config request, but it only contains 8 Elements if no authorized user is used
            }
            
        default:
            
            return value as? [JSON] != nil // Errors are delivered as Array
        }
        
        return false
    }
    
    private func handleErrors(_ jsonErrorArray: [JSON]) {
        
        for jsonError in jsonErrorArray {
            
            print("Hearbeat received Error Result", jsonError)
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
            print("Post Notification:", notification.rawValue)
            NotificationCenter.default.post(name: Notification.Name(rawValue: notification.rawValue), object: nil)
            
            self.lastLocalConnectionNotificationPostTime = Date().timeIntervalSince1970;
            
            // Make sure we instant notify about losing connection
            self.lastNoLocalConnectionNotificationPostTime = nil;
        }
    }
    
    private func notifyAboutNoLocalConnection() {
        
        if lastNoLocalConnectionNotificationPostTime == nil || Date().timeIntervalSince1970 - lastNoLocalConnectionNotificationPostTime! > 10 {
            
            let notification = BridgeHeartbeatConnectionStatusNotification(rawValue: "nolocalConnection")!
            print("Post Notification:", notification.rawValue)
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
            
            print("Post Notification: ", notification.rawValue)
            NotificationCenter.default.post(name: Notification.Name(rawValue: notification.rawValue), object: nil)
        }
    }
}
