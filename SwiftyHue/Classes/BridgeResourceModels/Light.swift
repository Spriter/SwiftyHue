//
//  Light.swift
//  Pods
//
//  Created by Marcel Dittmann on 21.04.16.
//
//

import Foundation
import Gloss

public class Light: BridgeResource, BridgeResourceDictGenerator {
    
    public typealias AssociatedBridgeResourceType = Light
    
    public let identifier: String
    public let name: String
    public let state: LightState
    public let type: String
    public let modelId: String
    public let uniqueId: String
    public let manufacturerName: String
    public let luminaireUniqueId: String?
    public let swVersion: String
    public let pointsymbol: String?
    
    public required init?(json: JSON) {
        
        guard let identifier: String = "id" <~~ json,
            let name: String = "name" <~~ json,
            let state: LightState = "state" <~~ json,
            let type: String = "type" <~~ json,
            let modelid: String = "modelid" <~~ json,
            let uniqueid: String = "uniqueid" <~~ json,
            let manufacturername: String = "manufacturername" <~~ json,
            let swversion: String = "swversion" <~~ json
        
            else { return nil }
        
        self.identifier = identifier
        self.name = name
        self.state = state
        self.type = type
        self.modelId = modelid
        self.uniqueId = uniqueid
        self.manufacturerName = manufacturername
        self.swVersion = swversion
        
        luminaireUniqueId = "luminaireuniqueid" <~~ json
        pointsymbol = "pointsymbol" <~~ json
        
    }
    
    public func toJSON() -> JSON? {
        
        var json = jsonify([
            "id" ~~> self.identifier,
            "name" ~~> self.name,
            "state" ~~> self.state,
            "type" ~~> self.type,
            "modelid" ~~> self.modelId,
            "uniqueid" ~~> self.uniqueId,
            "manufacturername" ~~> self.manufacturerName,
            "luminaireuniqueid" ~~> self.luminaireUniqueId,
            "swversion" ~~> self.swVersion,
            "pointsymbol" ~~> self.pointsymbol
            ])
        
        return json
    }
}

extension Light: Hashable {
    
    public var hashValue: Int {
        
        return Int(self.identifier)!
    }
}

public func ==(lhs: Light, rhs: Light) -> Bool {
    
    return lhs.identifier == rhs.identifier &&
        lhs.name == rhs.name &&
        lhs.state == rhs.state &&
        lhs.type == rhs.type &&
        lhs.modelId == rhs.modelId &&
        lhs.uniqueId == rhs.uniqueId &&
        lhs.manufacturerName == rhs.manufacturerName &&
        lhs.luminaireUniqueId == rhs.luminaireUniqueId &&
        lhs.swVersion == rhs.swVersion &&
        lhs.pointsymbol == rhs.pointsymbol
}