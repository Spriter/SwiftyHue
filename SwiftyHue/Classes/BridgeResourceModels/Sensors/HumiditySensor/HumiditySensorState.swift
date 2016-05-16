//
//  HumiditySensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class HumiditySensorState: SensorState {

    public let humidity: Int
    
    required public init?(json: JSON) {
        
        guard let humidity: Int = "humidity" <~~ json
            
            else { return nil }
        
        self.humidity = humidity
        
        super.init(json: json)
    }
    
    public override func toJSON() -> JSON? {
        
        if var superJson = super.toJSON() {
            var json = jsonify([
                "humidity" ~~> self.humidity
                ])
            superJson.unionInPlace(json!)
            return superJson
        }
        
        return nil
    }
}
