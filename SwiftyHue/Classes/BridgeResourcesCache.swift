//
//  BridgeResourcesCache.swift
//  Pods
//
//  Created by Marcel Dittmann on 23.04.16.
//
//

import Foundation
import Gloss

public enum ResourceCacheUpdateNotification: String {
    
    case LightsUpdated, GroupsUpdated, ScenesUpdated, SensorsUpdated, RulesUpdated, ConfigUpdated, SchedulesUpdated
    
    init?(resourceType: BridgeResourceType) {
        
        self.init(rawValue: resourceType.rawValue + "Updated")
    }
}

public class BridgeResourcesCache {
    
    public let lights: [String: Light];
    public let groups: [String: Group];
    public let schedules: [String: Schedule];
    public let scenes: [String: PartialScene];
    public let sensors: [String: Sensor];
    public let rules: [String: Rule];
    public let bridgeConfiguration: BridgeConfiguration?;
    
    public init() {

        lights = [String: Light]();
        groups = [String: Group]();
        schedules = [String: Schedule]();
        scenes = [String: PartialScene]();
        sensors = [String: Sensor]();
        rules = [String: Rule]();
        bridgeConfiguration = nil
        
    };
    
    public init(lights: [String: Light], groups: [String: Group], schedules: [String: Schedule], scenes: [String: PartialScene], sensors: [String: Sensor], rules: [String: Rule], bridgeConfiguration: BridgeConfiguration?) {
      
        self.lights = lights;
        self.groups = groups;
        self.schedules = schedules;
        self.scenes = scenes;
        self.sensors = sensors;
        self.rules = rules;
        self.bridgeConfiguration = bridgeConfiguration
    };
    
}

public class BridgeResourcesCacheManager {
 
    public static var sharedInstance = BridgeResourcesCacheManager();
    
    var lights = [String: Light]();
    var groups = [String: Group]();
    var schedules = [String: Schedule]();
    var scenes = [String: PartialScene]();
    var sensors = [String: Sensor]();
    var rules = [String: Rule]();
    var bridgeConfiguration: BridgeConfiguration?;

    init() {
        self.internCache = BridgeResourcesCache()
    }
    
    private func updateInternCache() {
    
        self.internCache = BridgeResourcesCache(lights: lights, groups: groups, schedules: schedules, scenes: scenes, sensors: sensors, rules: rules, bridgeConfiguration: bridgeConfiguration)
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
    
    private func store(json: JSON, resourceType: BridgeResourceType) {
        
        switch resourceType {
            
        case .Lights:
            self.lights = Light.dictionaryFromResourcesJSON(json)
        case .Groups:
            self.groups = Group.dictionaryFromResourcesJSON(json)
        case .Scenes:
            self.scenes = PartialScene.dictionaryFromResourcesJSON(json)
        case .Config:
            self.bridgeConfiguration = BridgeConfiguration(json: json)
        case .Schedules:
            self.schedules = Schedule.dictionaryFromResourcesJSON(json)
        case .Sensors:
            self.sensors = Sensor.dictionaryFromResourcesJSON(json)
        case .Rules:
            self.rules = Rule.dictionaryFromResourcesJSON(json)
        }
    }
    
    func notifyAboutChangesForResourceType(resourceType: BridgeResourceType) {
        
        let notification = ResourceCacheUpdateNotification(resourceType: resourceType)!
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