//
//  BridgeResource.swift
//  Pods
//
//  Created by Marcel Dittmann on 21.04.16.
//
//

import Foundation
import Gloss

public protocol BridgeResource: Decodable, Encodable {
    
    var identifier: String {get}
    var name: String {get}
}

/**
 Can create a dictionary of a specific BridgeResource (BridgeResourceType) from a JSON ([String: AnyObject]).
 */
public protocol BridgeResourceDictGenerator {
    
    associatedtype BridgeResourceType: BridgeResource
    
    static func dictionaryFromResourcesJSON(json: JSON) -> [String: BridgeResourceType]
}

public extension BridgeResourceDictGenerator {
    
    public static func dictionaryFromResourcesJSON(json: JSON) -> [String: BridgeResourceType] {
        
        var dict = [String: BridgeResourceType]();

        for (key, value) in json {

            var groupJSON = value as! JSON
            groupJSON["id"] = key

            if let group = BridgeResourceType(json: groupJSON) {
                dict[key as! String] = group;
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
