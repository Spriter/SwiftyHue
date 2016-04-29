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
    
    public let lights: [String: Light];
    public let groups: [String: Group];
    public let schedules: [String: AnyObject];
    public let scenes: [String: PartialScene];
    public let sensors: [String: AnyObject];
    public let rules: [String: AnyObject];
    
    var bridgeConfiguration: BridgeConfiguration?;
    
    public init() {

        lights = [String: Light]();
        groups = [String: Group]();
        schedules = [String: AnyObject]();
        scenes = [String: PartialScene]();
        sensors = [String: AnyObject]();
        rules = [String: AnyObject]();
        
    };
    
    public init(lights: [String: Light], groups: [String: Group], schedules: [String: AnyObject], scenes: [String: PartialScene], sensors: [String: AnyObject], rules: [String: AnyObject]) {
      
        self.lights = lights;
        self.groups = groups;
        self.schedules = schedules;
        self.scenes = scenes;
        self.sensors = sensors;
        self.rules = rules;
    };
    
}

public class BridgeResourcesCacheManager {
 
    public static var sharedInstance = BridgeResourcesCacheManager();
    
    var lights = [String: Light]();
    var groups = [String: Group]();
    var schedules = [String: AnyObject]();
    var scenes = [String: PartialScene]();
    var sensors = [String: AnyObject]();
    var rules = [String: AnyObject]();
    
    var bridgeConfiguration: BridgeConfiguration?;

    init() {
        self.internCache = BridgeResourcesCache()
    }
    
    private func updateInternCache() {
    
        self.internCache = BridgeResourcesCache(lights: lights, groups: groups, schedules: schedules, scenes: scenes, sensors: sensors, rules: rules)
    }
    
    var internCache: BridgeResourcesCache;
    
    public var cache: BridgeResourcesCache {
        
        return internCache;
    }
    
    func storeInObjectsCache(bridgeResourcesJSON:[BridgeResourceType: NSDictionary]) {
        
        for (key, value) in bridgeResourcesJSON {
            
            store(value as! JSON, resourceType: key)
        }
        
        // Update Intern Cache
        updateInternCache()
    }
    
    func storeInObjectsCache(json: JSON, resourceType: BridgeResourceType) {
        
        // convert to swift objects
        store(json, resourceType: resourceType)

        
        // Update Intern Cache
        updateInternCache()
        
        // Notify
        notifyAboutChangesForResourceType(resourceType)
    }
    
    func store(json: JSON, resourceType: BridgeResourceType) {
        
        switch resourceType {
            
        case .Lights:
            self.lights = Light.dictionaryFromResourcesJSON(json)
            break;
        case .Groups:
            self.groups = Group.dictionaryFromResourcesJSON(json)
            break;
        case .Scenes:
            self.scenes = PartialScene.dictionaryFromResourcesJSON(json)
            break;
        case .Config:
            break;
        case .Schedules:
            break;
        case .Sensors:
            break;
        case .Rules:
            break;
        }
    }
    
    func notifyAboutChangesForResourceType(resourceType: BridgeResourceType) {
        
        let notification = HeartbeatNotification(resourceType: resourceType)!
        NSNotificationCenter.defaultCenter().postNotificationName(notification.rawValue, object: nil)
    }
    
    
}
//public class BridgeResourcesCacheReader {
//
//    public class func readBridgeResourcesCache() -> BridgeResourcesCache {
//        
//        return BridgeResourcesCache();
//    }
//}