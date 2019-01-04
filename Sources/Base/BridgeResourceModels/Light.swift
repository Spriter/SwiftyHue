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
    
    public var resourceType: BridgeResourceType {
        return .light
    };
    
    /**
     Identifier of the light.
     */
    public let identifier: String
    
    /**
        A unique, editable name given to the light.
     */
    public let name: String
    
    /**
        Details the state of the light.     
     */
    public let state: LightState
    
    /**
        A fixed name describing the type of light e.g. “Extended color light”.
     */
    public let type: String
    
    /**
        The hardware model of the light.
     */
    public let modelId: String
    
    /**
        As of 1.4. Unique id of the device. The MAC address of the device with a unique endpoint id in the form: AA:BB:CC:DD:EE:FF:00:11-XX
     */
    public let uniqueId: String
    
    /**
        As of 1.7. The manufacturer name.
     */
    public let manufacturerName: String
    
    /**
        As of 1.9. Unique ID of the luminaire the light is a part of in the format: AA:BB:CC:DD-XX-YY.  AA:BB:, ... represents the hex of the luminaireid, XX the lightsource position (incremental but may contain gaps) and YY the lightpoint position (index of light in luminaire group).  A gap in the lightpoint position indicates an incomplete luminaire (light search required to discover missing light points in this case).
     */
    public let luminaireUniqueId: String?
    
    /**
        An identifier for the software version running on the light.
     */
    public let swVersion: String
    
    /**
        This parameter is reserved for future functionality. As from 1.11 point symbols are no longer returned.
     */
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
        
            else { print("Can't create Light from JSON:\n \(json)"); return nil }
        
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
        
        let json = jsonify([
            "id" ~~> identifier,
            "name" ~~> name,
            "state" ~~> state,
            "type" ~~> type,
            "modelid" ~~> modelId,
            "uniqueid" ~~> uniqueId,
            "manufacturername" ~~> manufacturerName,
            "luminaireuniqueid" ~~> luminaireUniqueId,
            "swversion" ~~> swVersion,
            "pointsymbol" ~~> pointsymbol
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
    return lhs.identifier == rhs.identifier
}
