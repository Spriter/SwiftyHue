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

    public typealias BridgeResourceType = Light
    
    public let identifier: String
    public let name: String
    public let state: LightState?
    public let type: String?
    public let modelid: String?
    public let uniqueid: String?
    public let manufacturername: String?
    public let luminaireuniqueid: String?
    public let swversion: String?
    public let pointsymbol: String?
    
    public required init?(json: JSON) {
        
        guard let identifier: String = "id" <~~ json,
            let name: String = "name" <~~ json
            else { return nil }
        
        self.identifier = identifier
        self.name = name
        
        state = "state" <~~ json
        type = "type" <~~ json
        modelid = "modelid" <~~ json
        uniqueid = "uniqueid" <~~ json
        manufacturername = "manufacturername" <~~ json
        luminaireuniqueid = "luminaireuniqueid" <~~ json
        swversion = "swversion" <~~ json
        pointsymbol = "pointsymbol" <~~ json
        
    }
    
    public func toJSON() -> JSON? {
        
        return [:]
    }
}