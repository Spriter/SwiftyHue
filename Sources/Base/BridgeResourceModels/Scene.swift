//
//  Scene.swift
//  Pods
//
//  Created by Marcel Dittmann on 21.04.16.
//
//

import Foundation
import Gloss

//public class Scene: PartialScene {
//    
//    public let lightstates: [LightState]?;
//    
//    public required init?(json: JSON) {
//        
//        var lightStates = json["lightstates"]
//        
//        if lightStates != nil {
//            
//            var lightstateJSONS = TestRequester.convert((lightStates as! NSDictionary).mutableCopy() as! NSMutableDictionary)
//            self.lightstates = Array.from(jsonArray: lightstateJSONS);
//        
//        } else {
//            self.lightstates = nil;
//        }
//        
//        super.init(json: json)
//    }
//    
//}

public class PartialScene: BridgeResource, BridgeResourceDictGenerator {
    
    public typealias AssociatedBridgeResourceType = PartialScene
    
    public var resourceType: BridgeResourceType {
        return .scene
    };
    
    /**
        The identifier of this scene.
     */
    public let identifier: String
    
    /**
        The name of this scene.
     */
    public let name: String

    /**
        The identifiers of the lights controlled by this scene.
     */
    public let lightIdentifiers: [String]?
    
    /**
        Whitelist user that created or modified the content of the scene. Note that changing name does not change the owner..
     */
    public let owner: String
    
    /**
        Indicates whether the scene can be automatically deleted by the bridge. Only available by POSTSet to 'false' when omitted. Legacy scenes created by PUT are defaulted to true. When set to 'false' the bridge keeps the scene until deleted by an application.
     */
    public let recycle: Bool
    
    /**
        Indicates that the scene is locked by a rule or a schedule and cannot be deleted until all resources requiring or that reference the scene are deleted.
     */
    public let locked: Bool
    
    /**
        App specific data linked to the scene.  Each individual application should take responsibility for the data written in this field.
     */
    public let appData: AppData?
    
    /**
        UTC time the scene has been created or has been updated by a PUT. Will be null when unknown (legacy scenes).
     */
    public let lastUpdated: Date?
    
    /**
        Version of scene document:
        1 - Scene created via PUT, lightstates will be empty.
        2 - Scene created via POST lightstates available.
    */
    public let version: Int
    
    public required init?(json: JSON) {
        
        guard let identifier: String = "id" <~~ json,
            let name: String = "name" <~~ json,
            let lightIdentifiers: [String] = "lights" <~~ json,
            let owner: String = "owner" <~~ json,
            let recycle: Bool = "recycle" <~~ json,
            let locked: Bool = "locked" <~~ json,
            let version: Int = "version" <~~ json
        
            else { print("Can't create Partial Scene from JSON:\n \(json)"); return nil }
        
        self.identifier = identifier
        self.name = name
        self.lightIdentifiers = lightIdentifiers
        self.owner = owner
        self.recycle = recycle
        self.locked = locked
        self.version = version
        
        let dateFormatter = DateFormatter.hueApiDateFormatter
        
        self.appData = "appdata" <~~ json
        lastUpdated = Decoder.decode(dateForKey:"lastupdated", dateFormatter:dateFormatter)(json)
    }
    
    public func toJSON() -> JSON? {
        
        let dateFormatter = DateFormatter.hueApiDateFormatter
        
        let json = jsonify([
            "id" ~~> identifier,
            "name" ~~> name,
            "lights" ~~> lightIdentifiers,
            "owner" ~~> owner,
            "recycle" ~~> recycle,
            "locked" ~~> locked,
            "appdata" ~~> appData,
            Encoder.encode(dateForKey: "lastupdated", dateFormatter: dateFormatter)(lastUpdated),
            "version" ~~> version
            ])
        
        return json
    }
    
}

extension PartialScene: Hashable {
    
    public var hashValue: Int {
        
        return Int(identifier)!
    }
}

public func ==(lhs: PartialScene, rhs: PartialScene) -> Bool {
    
    return lhs.identifier == rhs.identifier &&
        lhs.name == rhs.name &&
        (lhs.lightIdentifiers ?? []) == (rhs.lightIdentifiers ?? []) &&
        lhs.owner == rhs.owner &&
        lhs.recycle == rhs.recycle &&
        lhs.locked == rhs.locked &&
        lhs.appData == rhs.appData &&
        lhs.lastUpdated == rhs.lastUpdated &&
        lhs.version == rhs.version
}
