//
//  HumiditySensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class HumiditySensorState: PartialSensorState {

    public let humidity: Int
    
    init?(state: SensorState) {
        
        guard let humidity: Int = state.humidity else {
            Log.error("Can't create HumiditySensorState, missing required attribute \"humidity\""); return nil
        }
        
        self.humidity = humidity
        
        super.init(lastUpdated: state.lastUpdated)
    }
    
    required public init?(json: JSON) {
        
        guard let humidity: Int = "humidity" <~~ json else {
            Log.error("Can't create HumiditySensorState, missing required attribute \"humidity\" in JSON:\n \(json)"); return nil
        }
        
        self.humidity = humidity
        
        super.init(json: json)
    }
    
    public override func toJSON() -> JSON? {
        
        if var superJson = super.toJSON() {
            let json = jsonify([
                "humidity" ~~> self.humidity
                ])
            superJson.unionInPlace(json!)
            return superJson
        }
        
        return nil
    }
}

public func ==(lhs: HumiditySensorState, rhs: HumiditySensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated &&
        lhs.humidity == rhs.humidity
}