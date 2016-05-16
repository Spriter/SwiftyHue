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
        
        guard let presence: Bool = "presence" <~~ json
            
            else { return nil }
        
        self.presence = presence
        
        super.init(json: json)
    }
    
    public override func toJSON() -> JSON? {
        
        if var superJson = super.toJSON() {
            var json = jsonify([
                "presence" ~~> self.presence
                ])
            superJson.unionInPlace(json!)
            return superJson
        }
        
        return nil
    }
}
