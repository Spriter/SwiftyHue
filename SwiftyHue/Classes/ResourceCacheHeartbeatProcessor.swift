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
    
    init(delegate: ResourceCacheHeartbeatProcessorDelegate) {
        
        self.delegate = delegate
        self.resourceCache = BridgeResourcesCache()
        
        self.readCacheFromDisk()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ResourceCacheHeartbeatProcessor.handleApplicationWillTerminateNotification), name: UIApplicationWillTerminateNotification, object: nil)

    }
    
    @objc func handleApplicationWillTerminateNotification() {
     
        Log.trace("writeCacheToDisk because Application will terminate")
        self.writeCacheToDisk()
    }
    
    func processJSON(json: JSON, forResourceType resourceType: BridgeResourceType) {
        
        // Convert To Native Object
        
        if resourceType == .Config {
        
            let nativeObject = convertToNativeObject(json, resourceType: resourceType)
            
            // Store in Cache
            storeNativeObjectInCache(nativeObject, resourceType: resourceType)
    
        } else {
            
            let nativeObjectDict = convertToNativeObjectDict(json, resourceType: resourceType)
            
            // Store in Cache
            storeNativeObjectDictInCache(nativeObjectDict, resourceType: resourceType)
        }
        
        // Tell Delegate about update
        self.delegate.resourceCacheUpdated(resourceCache)

    }
    
    func storeNativeObjectInCache(bridgeResource: BridgeResource, resourceType: BridgeResourceType) {
        
        switch resourceType {
            case .Lights:
                break;
            case .Groups:
                 break;
            case .Scenes:
                 break;
            case .Config:
                self.resourceCache.setBridgeConfiguration(bridgeResource as! BridgeConfiguration)
            case .Schedules:
                 break;
            case .Sensors:
                 break;
            case .Rules:
                 break;
        }
    }
    
    func storeNativeObjectDictInCache(dict: NSDictionary, resourceType: BridgeResourceType) {
        
        switch resourceType {
            case .Lights:
                self.resourceCache.setLights(dict as! [String: Light])
            case .Groups:
                self.resourceCache.setGroups(dict as! [String: Group])
            case .Scenes:
                self.resourceCache.setScenes(dict as! [String: PartialScene])
            case .Config:
                break;
            case .Schedules:
                self.resourceCache.setSchedules(dict as! [String: Schedule])
            case .Sensors:
                self.resourceCache.setSensors(dict as! [String: Sensor])
            case .Rules:
                self.resourceCache.setRules(dict as! [String: Rule])
        }
    }
    
    func convertToNativeObjectDict(json: JSON, resourceType: BridgeResourceType) -> NSDictionary {
        
        //Log.debug("convertToNativeObjectDict", json)
        
        switch resourceType {
            
        case .Lights:
            return Light.dictionaryFromResourcesJSON(json)
        case .Groups:
            return Group.dictionaryFromResourcesJSON(json)
        case .Scenes:
            return PartialScene.dictionaryFromResourcesJSON(json)
        case .Config:
            break;
        case .Schedules:
            return Schedule.dictionaryFromResourcesJSON(json)
        case .Sensors:
            return Sensor.dictionaryFromResourcesJSON(json)
        case .Rules:
            return Rule.dictionaryFromResourcesJSON(json)
        }
        
        return [:]
    }
    
    func convertToNativeObject(json: JSON, resourceType: BridgeResourceType) -> BridgeResource {
        
        switch resourceType {
            
        case .Lights:
            return Light(json: json)!
        case .Groups:
            return Group(json: json)!
        case .Scenes:
            return PartialScene(json: json)!
        case .Config:
           return BridgeConfiguration(json: json)!
        case .Schedules:
            return Schedule(json: json)!
        case .Sensors:
            return Sensor(json: json)!
        case .Rules:
            return Rule(json: json)!
        }
    }
    
    private func writeCacheToDisk() {
        
        var encodedJSON = NSKeyedArchiver.archivedDataWithRootObject(self.resourceCache.toJSON()!)

        NSUserDefaults.standardUserDefaults().setObject(encodedJSON, forKey: "Cache")

    }
    
    private func readCacheFromDisk() {
        
        let encodedJSON = NSUserDefaults.standardUserDefaults().valueForKey("Cache") as? NSData
        
        if let encodedJSON = encodedJSON {
          
            Log.trace("readCacheFromDisk")
            
            let json = NSKeyedUnarchiver.unarchiveObjectWithData(encodedJSON) as! JSON
            
            let resourceCache = BridgeResourcesCache(json: json)!
            
            // Tell Delegate about update
            delegate.resourceCacheUpdated(resourceCache)
        }
    }
    
    var resourceCache: BridgeResourcesCache;
    
    func notifyAboutChangesForResourceType(resourceType: BridgeResourceType) {
        
        let notification = ResourceCacheUpdateNotification(resourceType: resourceType)!
        NSNotificationCenter.defaultCenter().postNotificationName(notification.rawValue, object: nil)
    }
}
