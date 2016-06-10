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
    
    case lightsUpdated, groupsUpdated, scenesUpdated, sensorsUpdated, rulesUpdated, configUpdated, schedulesUpdated
    
    init?(resourceType: HeartbeatBridgeResourceType) {
        
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
        
        #if os(iOS) || os(tvOS)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ResourceCacheHeartbeatProcessor.handleApplicationWillTerminateNotification), name: UIApplicationWillTerminateNotification, object: nil)
            
        #elseif os(watchOS)
            
// TODO:    We have to find a Solution for Watch OS
            
//            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ResourceCacheHeartbeatProcessor.handleApplicationWillTerminateNotification), name: UIApplicationWillResignActiveNotification, object: nil)
            
        #endif
        

    }
    
    @objc func handleApplicationWillTerminateNotification() {
     
        Log.trace("writeCacheToDisk because Application will terminate")
        self.writeCacheToDisk()
    }
    
    func processJSON(json: JSON, forResourceType resourceType: HeartbeatBridgeResourceType) {
        
        // Convert To Native Object
        
        if resourceType == .config {
        
            let nativeObject = convertToNativeObject(json, resourceType: resourceType)
            
             // Check if Object differs from the cached one
            if nativeObjectDiffersFromCache(nativeObject, resourceType: resourceType) {
             
                // Store in Cache
                storeNativeObjectInCache(nativeObject, resourceType: resourceType)
                
                // Notify about changed
                notifyAboutChangesForResourceType(resourceType)
            }
    
        } else {
            
            let nativeObjectDict = convertToNativeObjectDict(json, resourceType: resourceType)
            
            // Check if Objects Dict differs from the cached one
            if nativeObjectDictDiffersFromCache(nativeObjectDict, resourceType: resourceType) {
                
                // Store in Cache
                storeNativeObjectDictInCache(nativeObjectDict, resourceType: resourceType)
                
                // Notify about changed
                notifyAboutChangesForResourceType(resourceType)
            }
        }
        
        // Tell Delegate about update
        self.delegate.resourceCacheUpdated(resourceCache)

    }
    
    func storeNativeObjectInCache(bridgeResource: BridgeResource, resourceType: HeartbeatBridgeResourceType) {
        
        switch resourceType {
            case .lights:
                break;
            case .groups:
                 break;
            case .scenes:
                 break;
            case .config:
                self.resourceCache.setBridgeConfiguration(bridgeResource as! BridgeConfiguration)
                Log.info("Stored Native BridgeConfiguration Object In Cache")
            case .schedules:
                 break;
            case .sensors:
                 break;
            case .rules:
                 break;
        }
    }
    
    func storeNativeObjectDictInCache(dict: NSDictionary, resourceType: HeartbeatBridgeResourceType) {
        
        switch resourceType {
            case .lights:
                self.resourceCache.setLights(dict as! [String: Light])
                Log.info("Stored Native Lights Dict In Cache")
            case .groups:
                self.resourceCache.setGroups(dict as! [String: Group])
                Log.info("Stored Native Groups Dict In Cache")
            case .scenes:
                self.resourceCache.setScenes(dict as! [String: PartialScene])
                Log.info("Stored Native Scenes Dict In Cache")
            case .config:
                break;
            case .schedules:
                self.resourceCache.setSchedules(dict as! [String: Schedule])
                Log.info("Stored Native Schedules Dict In Cache")
            case .sensors:
                self.resourceCache.setSensors(dict as! [String: Sensor])
                Log.info("Stored Native Sensors Dict In Cache")
            case .rules:
                self.resourceCache.setRules(dict as! [String: Rule])
                Log.info("Stored Native Rules Dict In Cache")
        }
    }
    
    func nativeObjectDictDiffersFromCache(dict: NSDictionary, resourceType: HeartbeatBridgeResourceType) -> Bool {
        
        switch resourceType {
        case .lights:
            return self.resourceCache.lights != (dict as! [String: Light])
        case .groups:
            return self.resourceCache.groups != (dict as! [String: Group])
        case .scenes:
            return self.resourceCache.scenes != (dict as! [String: PartialScene])
        case .config:
            break;
        case .schedules:
            return self.resourceCache.schedules != (dict as! [String: Schedule])
        case .sensors:
            return self.resourceCache.sensors != (dict as! [String: Sensor])
        case .rules:
            return self.resourceCache.rules != (dict as! [String: Rule])
        }
        
        return false
    }
    
    func nativeObjectDiffersFromCache(bridgeResource: BridgeResource, resourceType: HeartbeatBridgeResourceType) -> Bool {
        
        switch resourceType {
        case .lights:
            return false
        case .groups:
            return false
        case .scenes:
            return false
        case .config:
            return self.resourceCache.bridgeConfiguration != bridgeResource as? BridgeConfiguration
        case .schedules:
            return false
        case .sensors:
            return false
        case .rules:
            return false
        }
        
        return false
    }
    
    func convertToNativeObjectDict(json: JSON, resourceType: HeartbeatBridgeResourceType) -> NSDictionary {
        
        //Log.debug("convertToNativeObjectDict", json)
        
        switch resourceType {
            
        case .lights:
            return Light.dictionaryFromResourcesJSON(json)
        case .groups:
            return Group.dictionaryFromResourcesJSON(json)
        case .scenes:
            return PartialScene.dictionaryFromResourcesJSON(json)
        case .config:
            break;
        case .schedules:
            return Schedule.dictionaryFromResourcesJSON(json)
        case .sensors:
            return convertToExplicitSensorObjectDict(json)
        case .rules:
            return Rule.dictionaryFromResourcesJSON(json)
        }
        
        return [:]
    }
    
    func convertToNativeObject(json: JSON, resourceType: HeartbeatBridgeResourceType) -> BridgeResource {
        
        switch resourceType {
            
        case .lights:
            return Light(json: json)!
        case .groups:
            return Group(json: json)!
        case .scenes:
            return PartialScene(json: json)!
        case .config:
           return BridgeConfiguration(json: json)!
        case .schedules:
            return Schedule(json: json)!
        case .sensors:
            return Sensor(json: json)!
        case .rules:
            return Rule(json: json)!
        }
    }
    
    private func convertToExplicitSensorObjectDict(json: JSON) -> NSDictionary {
        
        let dict: NSMutableDictionary = [:]
        
        for sensorJson in json {
            
            var sensorIdJson = sensorJson.1 as! JSON
            sensorIdJson["id"] = sensorJson.0
            
            if let sensorType: SensorType = "type" <~~ sensorIdJson {
                
                switch sensorType {
                case .CLIPGenericFlag:
                    dict[sensorJson.0] = GenericFlagSensor(json: sensorIdJson)
                case .CLIPGenericStatus:
                    dict[sensorJson.0] = GenericStatusSensor(json: sensorIdJson)
                case .CLIPHumidity:
                    dict[sensorJson.0] = HumiditySensor(json: sensorIdJson)
                case .CLIPOpenClose:
                    dict[sensorJson.0] = OpenCloseSensor(json: sensorIdJson)
                case .CLIPPresence:
                    dict[sensorJson.0] = PresenceSensor(json: sensorIdJson)
                case .CLIPTemperature:
                    dict[sensorJson.0] = TemperatureSensor(json: sensorIdJson)
                case .Daylight:
                    dict[sensorJson.0] = DaylightSensor(json: sensorIdJson)
                case .ClipSwitch,
                     .ZGPSwitch,
                     .ZLLSwitch:
                    dict[sensorJson.0] = SwitchSensor(json: sensorIdJson)
                }
            }
        }

        return dict
    }
    
    private func writeCacheToDisk() {
        
        var encodedJSON = NSKeyedArchiver.archivedDataWithRootObject(self.resourceCache.toJSON()!)
        NSUserDefaults.standardUserDefaults().setObject(encodedJSON, forKey: "CacheX")
        
        Log.info("writeCacheToDisk")

    }
    
    private func readCacheFromDisk() {
        
        let encodedJSON = NSUserDefaults.standardUserDefaults().valueForKey("CacheX") as? NSData
        
        if let encodedJSON = encodedJSON {
          
            Log.info("readCacheFromDisk")
            
            let json = NSKeyedUnarchiver.unarchiveObjectWithData(encodedJSON) as! JSON
                        
            let resourceCache = BridgeResourcesCache(json: json)!
            self.resourceCache = resourceCache
            
            // Tell Delegate about update
            delegate.resourceCacheUpdated(resourceCache)
        }
    }
    
    var resourceCache: BridgeResourcesCache;
    
    func notifyAboutChangesForResourceType(resourceType: HeartbeatBridgeResourceType) {
        
        let notification = ResourceCacheUpdateNotification(resourceType: resourceType)!
        Log.info("notifyAboutChangesForResourceType: \(notification.rawValue)")
        NSNotificationCenter.defaultCenter().postNotificationName(notification.rawValue, object: nil)
    }
}
