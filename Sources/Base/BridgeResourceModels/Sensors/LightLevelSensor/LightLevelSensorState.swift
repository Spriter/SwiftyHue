//
//  LightlevelSensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 08.11.19.
//
//

import Foundation
import Gloss

public class LightLevelSensorState: PartialSensorState {

    public let lightlevel: Int?
    public let dark: Bool?
    public let daylight: Bool?
    
    init?(state: SensorState) {
        
        self.lightlevel = state.lightlevel
        self.dark = state.dark
        self.daylight = state.daylight
        
        super.init(lastUpdated: state.lastUpdated)
    }
    
    required public init?(json: JSON) {
        
        guard let lightlevel: Int = "lightlevel" <~~ json else {
            print("Can't create LightlevelSensorState, missing required attribute \"lightlevel\" in JSON:\n \(json)"); return nil
        }
        self.lightlevel = lightlevel
        
        guard let dark: Bool = "dark" <~~ json else {
            print("Can't create LightlevelSensorState, missing required attribute \"dark\" in JSON:\n \(json)"); return nil
        }
        self.dark = dark
        
        guard let daylight: Bool = "daylight" <~~ json else {
            print("Can't create LightlevelSensorState, missing required attribute \"daylight\" in JSON:\n \(json)"); return nil
        }
        self.daylight = daylight
        
        super.init(json: json)
    }
    
    public override func toJSON() -> JSON? {
        
        if var superJson = super.toJSON() {
            let json = jsonify([
                "lightlevel" ~~> self.lightlevel,
                "dark" ~~> self.dark,
                "daylight" ~~> self.daylight
                ])
            superJson.unionInPlace(json!)
            return superJson
        }

        return nil
    }
}

public func ==(lhs: LightLevelSensorState, rhs: LightLevelSensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated &&
        lhs.lightlevel == rhs.lightlevel &&
        lhs.dark == lhs.dark &&
        lhs.daylight == lhs.daylight
}
