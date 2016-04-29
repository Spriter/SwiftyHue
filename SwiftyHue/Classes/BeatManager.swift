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

public enum HeartbeatNotification: String {
    
    case LightsUpdated, GroupsUpdated, ScenesUpdated, SensorsUpdated, RulesUpdated, ConfigUpdated, SchedulesUpdated
    
    init?(resourceType: BridgeResourceType) {
        
        self.init(rawValue: resourceType.rawValue + "Updated")
    }
}

public enum BridgeResourceType: String {
    case Lights, Groups, Scenes, Sensors, Rules, Config, Schedules
}

public class BeatManager {
    
    private var bridgeAcc = "hkoPdsoXKRVsbI6wcPWdcu4ud0jnIEhfoP4GftxY";
    private var bridgeIp = "192.168.0.10"
    
    var localHeartbeatTimers = [BridgeResourceType: NSTimer]()
    var bridgeResourcesCacheManager = BridgeResourcesCacheManager();

    public init() {

    }
    
    public func setLocalHeartbeatInterval(interval: NSTimeInterval, forResourceType resourceType: BridgeResourceType) {
        
        localHeartbeatTimers[resourceType] = NSTimer(timeInterval: interval, target: self, selector: #selector(BeatManager.timerAction), userInfo: resourceType.rawValue, repeats: true);
    }
    
    public func removeLocalHeartbeatInterval(interval: Float, forResourceType resourceType: BridgeResourceType) {
        
        if let timer = localHeartbeatTimers.removeValueForKey(resourceType) {
            
            timer.invalidate()
        }
    }
    
    public func startHeartbeat() {
       
        for timer in localHeartbeatTimers.values {
            NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        }
    }
    
    @objc func timerAction(timer: NSTimer) {
        
        let resourceType: BridgeResourceType = BridgeResourceType(rawValue: timer.userInfo! as! String)!
        
        Alamofire.request(.GET, "http://\(bridgeIp)/api/\(bridgeAcc)/\(resourceType.rawValue.lowercaseString)", parameters: nil)
            .responseJSON { response in
                
                if let resultValueJSON = response.result.value as? NSMutableDictionary {
                    
                    self.bridgeResourcesCacheManager.processJSON(resultValueJSON, resourceType: resourceType)
                }
        }
    
    }
}