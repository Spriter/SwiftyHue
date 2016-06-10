//
//  GenericFlagSensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class GenericFlagSensorState: SensorState {
    
    public let flag: Bool
    
    required public init?(json: JSON) {
        
        guard let flag: Bool = "flag" <~~ json else {
            Log.error("Can't create GenericFlagSensorState, missing required attribute \"flag\" in JSON:\n \(json)"); return nil
        }
        
        self.flag = flag
        
        super.init(json: json)
    }
    
    public override func toJSON() -> JSON? {
        
        if var superJson = super.toJSON() {
            let json = jsonify([
                "flag" ~~> flag
                ])
            superJson.unionInPlace(json!)
            return superJson
        }
        
        return nil
    }
}

public func ==(lhs: GenericFlagSensorState, rhs: GenericFlagSensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated &&
        lhs.flag == rhs.flag
}