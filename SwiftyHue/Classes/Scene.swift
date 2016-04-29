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
//            self.lightstates = Array.fromJSONArray(lightstateJSONS);
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
    
    public let identifier: String
    public let name: String
    public let lightIdentifiers: [String]
    public let owner: String
    public let recycle: Bool
    public let locked: Bool
    public let appdata: AppData?
    public let picture: String?
    public let lastupdated: NSDate?
    public let version: Int
    
    public required init?(json: JSON) {
        
        guard let identifier: String = "id" <~~ json,
            let name: String = "name" <~~ json,
            let lightIdentifiers: [String] = "lights" <~~ json,
            let owner: String = "owner" <~~ json,
            let recycle: Bool = "recycle" <~~ json,
            let locked: Bool = "locked" <~~ json,
            let version: Int = "version" <~~ json
        
            else { return nil }
        
        self.identifier = identifier
        self.name = name
        self.lightIdentifiers = lightIdentifiers
        self.owner = owner
        self.recycle = recycle
        self.locked = locked
        self.version = version
        
        let dateFormatter = NSDateFormatter.hueApiDateFormatter
        
        self.appdata = "appdata" <~~ json
        picture = "picture" <~~ json
        lastupdated = Decoder.decodeDate("lastupdated", dateFormatter:dateFormatter)(json)
    }
    
    public func toJSON() -> JSON? {
        
        let dateFormatter = NSDateFormatter.hueApiDateFormatter
        
        var json = jsonify([
            "identifier" ~~> self.identifier,
            "name" ~~> self.name,
            "lights" ~~> self.lightIdentifiers,
            "owner" ~~> self.owner,
            "recycle" ~~> self.recycle,
            "locked" ~~> self.locked,
            "appdata" ~~> self.appdata,
            "picture" ~~> self.picture,
            "lastupdated" ~~> Encoder.encodeDate("lastupdated", dateFormatter: dateFormatter)(self.lastupdated),
            "version" ~~> self.version
            ])
        
        return json
    }
    
}