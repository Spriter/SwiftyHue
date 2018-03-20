//
//  TemperatureSensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class TemperatureSensorState: PartialSensorState {

    public let temperature: Int
    
    init?(state: SensorState) {
        
        guard let temperature: Int = state.temperature else {
            print("Can't create TemperatureSensorState, missing required attribute \"temperature\""); return nil
        }
        
        self.temperature = temperature
        
        super.init(lastUpdated: state.lastUpdated)
    }
    
    required public init?(json: JSON) {
        
        guard let temperature: Int = "temperature" <~~ json else {
            print("Can't create TemperatureSensorState, missing required attribute \"temperature\" in JSON:\n \(json)"); return nil
        }
        
        self.temperature = temperature
        
        super.init(json: json)
    }
    
    public override func toJSON() -> JSON? {
        
        if var superJson = super.toJSON() {
            let json = jsonify([
                "temperature" ~~> self.temperature
                ])
            superJson.unionInPlace(json!)
            return superJson
        }
        
        return nil
    }
}

public func ==(lhs: TemperatureSensorState, rhs: TemperatureSensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated &&
        lhs.temperature == rhs.temperature
}
