//
//  BridgeResource.swift
//  Pods
//
//  Created by Marcel Dittmann on 21.04.16.
//
//

import Foundation
import Gloss

public enum BridgeResourceType: String {
    case light, group, scene, sensor, rule, config, schedule, whitelistEntry
}

public protocol BridgeResource: Glossy {
    
    var identifier: String {get}
    var name: String {get}
    var resourceType: BridgeResourceType {get};
}

/**
 Can create a dictionary of a specific BridgeResource (BridgeResourceType) from a JSON ([String: AnyObject]).
 */
public protocol BridgeResourceDictGenerator {
    
    associatedtype AssociatedBridgeResourceType: BridgeResource
    
    static func dictionaryFromResourcesJSON(_ json: JSON) -> [String: AssociatedBridgeResourceType]
}

public extension BridgeResourceDictGenerator {
    
    static func dictionaryFromResourcesJSON(_ json: JSON) -> [String: AssociatedBridgeResourceType] {
        
        var dict = [String: AssociatedBridgeResourceType]();

        for (key, value) in json {

            var resourceJSON = value as! JSON
            resourceJSON["id"] = key

            if let resource = AssociatedBridgeResourceType(json: resourceJSON) {
                dict[key ] = resource;
            }
        }
        
        return dict;
    }
}

//extension BridgeResource {
//    
//    public init?(json: JSON) {
//        
//        self.init()
//        
//        identifier = "id" <~~ json
//        name = "name" <~~ json
//        
//    }
//    
//    /**
//     Object encoded as JSON
//     */
//    public func toJSON() -> JSON? {
//        
//        return jsonify([
//            "id" ~~> self.identifier,
//            "login" ~~> self.name
//            ])
//    }
//    
//    public static func dictionaryOf(json: JSON) -> [String: BridgeResource]? {
//        
//        var dict = [String: BridgeResource]();
//        
//        for (key, value) in json {
//            
//            var groupJSON = value as! JSON
//            groupJSON["id"] = key
//            
//            if let group = self.init(json: groupJSON) {
//                dict[key as! String] = group;
//            }
//            
//        }
//        
//        return nil;
//    }
//}
