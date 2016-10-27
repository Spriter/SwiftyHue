//
//  SoftwareUpdateStatusDeviceTypes.swift
//  Pods
//
//  Created by Marcel Dittmann on 22.04.16.
//
//

import Foundation
import Gloss

public struct SoftwareUpdateStatusDeviceTypes: Decodable, Encodable {
    
    /**
     Flag for when bridge update is avaliable
     */
    public let bridge: Bool?
    
    /**
     List of IDs of lights to be updated.
     */
    public let lights: [String]?
    
    /**
     List of IDs of sensors to be updated
     */
    public let sensors: [String]?
    
    public init?(json: JSON) {
        
        bridge = "bridge" <~~ json
        lights = "lights" <~~ json
        sensors = "sensors" <~~ json
        
    }
    
    public func toJSON() -> JSON? {
        
        let json = jsonify([
            "bridge" ~~> bridge,
            "lights" ~~> lights,
            "sensors" ~~> sensors,
            ])
        
        return json
    }
}

extension SoftwareUpdateStatusDeviceTypes: Hashable {
    
    public var hashValue: Int {
        
        return 1
    }
}

public func ==(lhs: SoftwareUpdateStatusDeviceTypes, rhs: SoftwareUpdateStatusDeviceTypes) -> Bool {
    return (lhs.bridge ?? false) == (rhs.bridge ?? false) &&
        (lhs.lights ?? []) == (rhs.lights ?? []) &&
        (lhs.sensors ?? []) == (rhs.sensors ?? [])
}
