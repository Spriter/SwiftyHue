//
//  Humidity.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation

public class HumiditySensor: PartialSensor {
    
    let config: HumiditySensorConfig
    let state: HumiditySensorState
    
    required public init?(sensor: Sensor) {
        
        guard let sensorConfig = sensor.config else {
            return nil
        }
        
        guard let sensorState = sensor.state else {
            return nil
        }
        
        guard let config: HumiditySensorConfig = HumiditySensorConfig(sensorConfig: sensorConfig) else {
            return nil
        }
        
        guard let state: HumiditySensorState = HumiditySensorState(state: sensorState) else {
            return nil
        }
        
        self.config = config
        self.state = state
        
        super.init(identifier: sensor.identifier, uniqueId: sensor.uniqueId, name: sensor.name, type: sensor.type, modelId: sensor.modelId, manufacturerName: sensor.manufacturerName, swVersion: sensor.swVersion, recycle: sensor.recycle)
    }
    
    public required init?(json: [String: Any]) {
        guard let configJSON = json["config"] as? [String: Any],
              let config: HumiditySensorConfig = HumiditySensorConfig(json: configJSON) else {
            return nil
        }

        guard let stateJSON = json["state"] as? [String: Any],
              let state: HumiditySensorState = HumiditySensorState(json: stateJSON) else {
            return nil
        }
        
        self.config = config
        self.state = state
        
        super.init(json: json)
    }
}

public func ==(lhs: HumiditySensor, rhs: HumiditySensor) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.name == rhs.name &&
        lhs.state == rhs.state &&
        lhs.config == rhs.config &&
        lhs.type == rhs.type &&
        lhs.modelId == rhs.modelId &&
        lhs.manufacturerName == rhs.manufacturerName &&
        lhs.swVersion == rhs.swVersion
}
