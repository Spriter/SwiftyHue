//
//  BridgeResourcesCache.swift
//  Pods
//
//  Created by Marcel Dittmann on 23.04.16.
//
//

import Foundation
import Gloss

public class BridgeResourcesCache {
    
    static var sharedInstance = BridgeResourcesCache();
    
    let lights = [Light]();
    let groups = [Group]();
    let schedules = [AnyObject]();
    let scenes = [PartialScene]();
    let sensors = [AnyObject]();
    let rules = [AnyObject]();
    
    var bridgeConfiguration: BridgeConfiguration?;
    
    private init() {
        
    };
    
}

class BridgeResourcesCacheManager {
 
    var bridgeResourcesCache = BridgeResourcesCache.sharedInstance
    var lastProcessedJSONs = [BridgeResourceType: NSMutableDictionary]()
    
    init() {
        readCacheFromDisk()
    }
    
    private func readCacheFromDisk() {
        
        let resourceTypes: [BridgeResourceType] = [.Lights, .Groups, .Scenes, .Sensors, .Rules, .Config, .Schedules]
        
        for resourceType in resourceTypes {
            
            if let resourcesJSON = self.readFromDisk(resourceType) {
                
                lastProcessedJSONs[resourceType] = resourcesJSON;
                storeInObjectsCache(resourcesJSON as! JSON, resourceType: resourceType)
            }
        }
    }
    
    func storeInObjectsCache(json: JSON, resourceType: BridgeResourceType) {
        
        // convert to swift objects
    }
    
    func processJSON(json: NSMutableDictionary, resourceType: BridgeResourceType) {
        
        if let resultValueJSON = json as? NSMutableDictionary {
            
            if self.lastProcessedJSONs[resourceType] != resultValueJSON {
                
                let notification = HeartbeatNotification(resourceType: resourceType)!
                NSNotificationCenter.defaultCenter().postNotificationName(notification.rawValue, object: nil)
                print("Changes for \(resourceType.rawValue)")
                
                self.lastProcessedJSONs[resourceType] = resultValueJSON
                self.writeToDisk(resultValueJSON, resourceType: resourceType)
            }
        }
    }
    
    func writeToDisk(lastJSON: NSMutableDictionary, resourceType: BridgeResourceType) {
        
        NSUserDefaults.standardUserDefaults().setObject(lastJSON, forKey: userDefaultsKeyForResourceType(resourceType))
    }
    
    func readFromDisk(resourceType: BridgeResourceType) -> NSMutableDictionary? {
        
        return NSUserDefaults.standardUserDefaults().valueForKey(userDefaultsKeyForResourceType(resourceType)) as? NSMutableDictionary
    }
    
    func userDefaultsKeyForResourceType(resourceType: BridgeResourceType) -> String {
        
        return resourceType.rawValue + "Cache"
    }
    
}
//public class BridgeResourcesCacheReader {
//
//    public class func readBridgeResourcesCache() -> BridgeResourcesCache {
//        
//        return BridgeResourcesCache();
//    }
//}