//
//  BeatProcessor.swift
//  Pods
//
//  Created by Marcel Dittmann on 29.04.16.
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

protocol ResourceCacheHeartbeatProcessorDelegate: class {
    
    func resourceCacheUpdated(resourceCache: BridgeResourcesCache)
}

class ResourceCacheHeartbeatProcessor: HeartbeatProcessor {
    
    unowned var delegate: ResourceCacheHeartbeatProcessorDelegate
    
    var lastProcessedJSONs = [BridgeResourceType: NSDictionary]()
    
    init(delegate: ResourceCacheHeartbeatProcessorDelegate) {
        
        self.delegate = delegate
        
        self.resourceCache = BridgeResourcesCache()
        
        readCacheFromDisk()
        
        storeInObjectsCache(lastProcessedJSONs)

    }
    
    func processJSON(json: JSON, forResourceType resourceType: BridgeResourceType) {
        
        if self.lastProcessedJSONs[resourceType] != json {
              
            self.lastProcessedJSONs[resourceType] = json
            self.writeToDisk(json, resourceType: resourceType)
            
            storeInObjectsCache(json, resourceType: resourceType)
        }
        
    }
    
    func writeToDisk(lastJSON: JSON, resourceType: BridgeResourceType) {
        
        let encodedJSON = NSKeyedArchiver.archivedDataWithRootObject(lastJSON)
        
        NSUserDefaults.standardUserDefaults().setObject(encodedJSON, forKey: userDefaultsKeyForResourceType(resourceType))
    
    }
    
    func readFromDisk(resourceType: BridgeResourceType) -> JSON? {
        
        let encodedJSON = NSUserDefaults.standardUserDefaults().valueForKey(userDefaultsKeyForResourceType(resourceType)) as? NSData
        
        var json: JSON?
        if let encodedJSON = encodedJSON {
            
            json = NSKeyedUnarchiver.unarchiveObjectWithData(encodedJSON) as? JSON
        }
        
        return json
    }
    
    func userDefaultsKeyForResourceType(resourceType: BridgeResourceType) -> String {
        
        return resourceType.rawValue + "Cache"
    }
    
    private func readCacheFromDisk() {
        
        let resourceTypes: [BridgeResourceType] = [.Lights, .Groups, .Scenes, .Sensors, .Rules, .Config, .Schedules]
        
        for resourceType in resourceTypes {
            
            if let resourcesJSON = self.readFromDisk(resourceType) {
                
                lastProcessedJSONs[resourceType] = resourcesJSON;
               
            }
        }
    }

    // MARK Nativ Stuff
    
    var resourceCache: BridgeResourcesCache;
    
    func storeInObjectsCache(bridgeResourcesJSON:[BridgeResourceType: NSDictionary]) {
        
        for (key, value) in bridgeResourcesJSON {
            
            store(value as! JSON, resourceType: key)
        }
        
        // Tell Delegate about update
        delegate.resourceCacheUpdated(resourceCache)
    }
    
    func storeInObjectsCache(json: JSON, resourceType: BridgeResourceType) {
        
        // convert to swift objects
        store(json, resourceType: resourceType)
        
        // Tell Delegate about update
        delegate.resourceCacheUpdated(resourceCache)
        
        // Notify
        notifyAboutChangesForResourceType(resourceType)
    }
    
    private func store(json: JSON, resourceType: BridgeResourceType) {
        
        switch resourceType {
            
        case .Lights:
            self.resourceCache.setLights(Light.dictionaryFromResourcesJSON(json))
        case .Groups:
            self.resourceCache.setGroups(Group.dictionaryFromResourcesJSON(json))
        case .Scenes:
            self.resourceCache.setScenes(PartialScene.dictionaryFromResourcesJSON(json))
        case .Config:
            self.resourceCache.setBridgeConfiguration(BridgeConfiguration(json: json)!)
        case .Schedules:
            self.resourceCache.setSchedules(Schedule.dictionaryFromResourcesJSON(json))
        case .Sensors:
            self.resourceCache.setSensors(Sensor.dictionaryFromResourcesJSON(json))
        case .Rules:
            self.resourceCache.setRules(Rule.dictionaryFromResourcesJSON(json))
        }
    }
    
    func notifyAboutChangesForResourceType(resourceType: BridgeResourceType) {
        
        let notification = ResourceCacheUpdateNotification(resourceType: resourceType)!
        NSNotificationCenter.defaultCenter().postNotificationName(notification.rawValue, object: nil)
    }
        
        
}
