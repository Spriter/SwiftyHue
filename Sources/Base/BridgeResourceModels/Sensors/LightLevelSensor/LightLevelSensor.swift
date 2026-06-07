//
//  LightLevelSensor.swift
//  Pods
//
//  Created by Jerome Schmitz on 08.11.19.
//
//

import Foundation

public class LightLevelSensor: PartialSensor {
    
    let config: LightLevelSensorConfig
    let state: LightLevelSensorState
    
    required public init?(sensor: Sensor) {
        
        guard let sensorConfig = sensor.config else {
            return nil
        }
        
        guard let sensorState = sensor.state else {
            return nil
        }
        
        guard let config: LightLevelSensorConfig = LightLevelSensorConfig(sensorConfig: sensorConfig) else {
            return nil
        }
        
        guard let state: LightLevelSensorState = LightLevelSensorState(state: sensorState) else {
            return nil
        }
        
        self.config = config
        self.state = state
        
        super.init(identifier: sensor.identifier, uniqueId: sensor.uniqueId, name: sensor.name, type: sensor.type, modelId: sensor.modelId, manufacturerName: sensor.manufacturerName, swVersion: sensor.swVersion, recycle: sensor.recycle)
    }
    
    public required init?(json: [String: Any]) {
        guard let configJSON = json["config"] as? [String: Any],
              let config: LightLevelSensorConfig = LightLevelSensorConfig(json: configJSON) else {
            return nil
        }

        guard let stateJSON = json["state"] as? [String: Any],
              let state: LightLevelSensorState = LightLevelSensorState(json: stateJSON) else {
            return nil
        }
        
        self.config = config
        self.state = state
        
        super.init(json: json)
    }
}

public func ==(lhs: LightLevelSensor, rhs: LightLevelSensor) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.name == rhs.name &&
        lhs.state == rhs.state &&
        lhs.config == rhs.config &&
        lhs.type == rhs.type &&
        lhs.modelId == rhs.modelId &&
        lhs.manufacturerName == rhs.manufacturerName &&
        lhs.swVersion == rhs.swVersion
}
