//
//  BeatProcessor.swift
//  Pods
//
//  Created by Marcel Dittmann on 29.04.16.
//
//

import Foundation
import Gloss

class BeatProcessor {
    
    var bridgeResourceCacheManager = BridgeResourcesCacheManager.sharedInstance
    var lastProcessedJSONs = [BridgeResourceType: NSDictionary]()
    
    init() {
        
        readCacheFromDisk()
        bridgeResourceCacheManager.storeInObjectsCache(lastProcessedJSONs)
    }
    
    func processJSON(json: JSON, resourceType: BridgeResourceType) {
        
        if self.lastProcessedJSONs[resourceType] != json {
              
            self.lastProcessedJSONs[resourceType] = json
            self.writeToDisk(json, resourceType: resourceType)
            bridgeResourceCacheManager.storeInObjectsCache(json, resourceType: resourceType)
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

    
}