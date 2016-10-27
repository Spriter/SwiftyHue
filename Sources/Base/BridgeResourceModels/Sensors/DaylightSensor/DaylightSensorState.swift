//
//  DaylightSensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class DaylightSensorState: PartialSensorState {

    public let daylight: Bool?
    
    init?(state: SensorState) {
        
        self.daylight = state.daylight
        
        super.init(lastUpdated: state.lastUpdated)
    }
    
    required public init?(json: JSON) {
        
        guard let daylight: Bool = "daylight" <~~ json else {
            Log.error("Can't create DaylightSensorState, missing required attribute \"daylight\" in JSON:\n \(json)"); return nil
        }
        
        self.daylight = daylight
        
        super.init(json: json)
    }
    
    public override func toJSON() -> JSON? {
        
        if var superJson = super.toJSON() {
            let json = jsonify([
                "daylight" ~~> self.daylight
                ])
            superJson.unionInPlace(json!)
            return superJson
        }

        return nil
    }
}

public func ==(lhs: DaylightSensorState, rhs: DaylightSensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated &&
        lhs.daylight == rhs.daylight
}