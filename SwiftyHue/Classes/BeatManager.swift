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

public class BeatManager {
    
    private let bridgeAccesssConfig: BridgeAccesssConfig;
    
    var localHeartbeatTimers = [BridgeResourceType: NSTimer]()
    var localHeartbeatTimerIntervals = [BridgeResourceType: NSTimeInterval]()
    
    var beatProcessor = BeatProcessor();

    public init(bridgeAccesssConfig: BridgeAccesssConfig) {
        self.bridgeAccesssConfig = bridgeAccesssConfig
    }
    
    public func setLocalHeartbeatInterval(interval: NSTimeInterval, forResourceType resourceType: BridgeResourceType) {
        
        localHeartbeatTimerIntervals[resourceType] = interval
    }
    
    public func removeLocalHeartbeatInterval(interval: Float, forResourceType resourceType: BridgeResourceType) {
        
        if let timer = localHeartbeatTimers.removeValueForKey(resourceType) {
            
            timer.invalidate()
        }
    }
    
    public func startHeartbeat() {
       
        for (resourceType, timerInterval) in localHeartbeatTimerIntervals {
            
            // Create Timer
            let timer = NSTimer(timeInterval: timerInterval, target: self, selector: #selector(BeatManager.timerAction), userInfo: resourceType.rawValue, repeats: true);
            
            // Store timer
            localHeartbeatTimers[resourceType] = timer;
            
            // Add Timer to RunLoop
            NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        }
    }
    
    public func stopHeartbeat() {
        
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
                        
                        self.beatProcessor.processJSON(resultValueJSON, resourceType: resourceType)
                    }
                    
                case .Failure(let error):
                    NSNotificationCenter.defaultCenter().postNotificationName(BridgeConnectionStatusNotification.nolocalConnection.rawValue, object: nil)
                }
        }
    
    }
}