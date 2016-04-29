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
    public let modelid: String
    public let uniqueid: String
    public let manufacturername: String
    public let luminaireuniqueid: String?
    public let swversion: String
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
        self.modelid = modelid
        self.uniqueid = uniqueid
        self.manufacturername = manufacturername
        self.swversion = swversion
        
        luminaireuniqueid = "luminaireuniqueid" <~~ json
        pointsymbol = "pointsymbol" <~~ json
        
    }
    
    public func toJSON() -> JSON? {
        
        var json = jsonify([
            "id" ~~> self.identifier,
            "name" ~~> self.name,
            "state" ~~> self.state,
            "type" ~~> self.type,
            "modelid" ~~> self.modelid,
            "uniqueid" ~~> self.uniqueid,
            "manufacturername" ~~> self.manufacturername,
            "swversion" ~~> self.swversion
            ])
        
        return json
    }
}