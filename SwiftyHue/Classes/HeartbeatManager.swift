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

public enum BridgeConnectionStatusNotification: String {
    
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
            
        Alamofire.request(.GET, "http://\(bridgeAccesssConfig.ipAddress)/api/\(bridgeAccesssConfig.username)/\(resourceType.rawValue.lowercaseString)", parameters: nil)
            .responseJSON { response in
                
                switch response.result {
                case .Success:
                    
                    if let resultValueJSON = response.result.value as? JSON {
                        
                        for heartbeatProcessor in self.heartbeatProcessors {
                            heartbeatProcessor.processJSON(resultValueJSON, forResourceType: resourceType)
                        }
                    }
                    
                case .Failure(let error):
                    NSNotificationCenter.defaultCenter().postNotificationName(BridgeConnectionStatusNotification.nolocalConnection.rawValue, object: nil)
                }
        }
    
    }
}