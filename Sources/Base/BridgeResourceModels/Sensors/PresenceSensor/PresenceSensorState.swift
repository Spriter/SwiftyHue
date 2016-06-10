//
//  PresenceSensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class PresenceSensorState: SensorState {

    public let presence: Bool
    
    required public init?(json: JSON) {
        
        guard let presence: Bool = "presence" <~~ json else {
            Log.error("Can't create PresenceSensorState, missing required attribute \"presence\" in JSON:\n \(json)"); return nil
        }
        
        self.presence = presence
        
        super.init(json: json)
    }
    
    public override func toJSON() -> JSON? {
        
        if var superJson = super.toJSON() {
            let json = jsonify([
                "presence" ~~> self.presence
                ])
            superJson.unionInPlace(json!)
            return superJson
        }
        
        return nil
    }
}

public func ==(lhs: PresenceSensorState, rhs: PresenceSensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated &&
        lhs.presence == rhs.presence
}