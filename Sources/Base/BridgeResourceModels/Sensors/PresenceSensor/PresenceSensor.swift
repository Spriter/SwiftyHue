//
//  PresenceSensor.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class PresenceSensor: PartialSensor {
    
    let config: GenericFlagSensorConfig
    let state: GenericFlagSensorState
    
    required public init?(sensor: Sensor) {
        
        guard let sensorConfig = sensor.config else {
            return nil
        }
        
        guard let sensorState = sensor.state else {
            return nil
        }
        
        guard let config: GenericFlagSensorConfig = GenericFlagSensorConfig(sensorConfig: sensorConfig) else {
            return nil
        }
        
        guard let state: GenericFlagSensorState = GenericFlagSensorState(state: sensorState) else {
            return nil
        }
        
        self.config = config
        self.state = state
        
        super.init(identifier: sensor.identifier, uniqueId: sensor.uniqueId, name: sensor.name, type: sensor.type, modelId: sensor.modelId, manufacturerName: sensor.manufacturerName, swVersion: sensor.swVersion, recycle: sensor.recycle)
    }
    
    public required init?(json: JSON) {
        
        guard let config: GenericFlagSensorConfig = "config" <~~ json else {
            return nil
        }
        
        guard let state: GenericFlagSensorState = "state" <~~ json else {
            return nil
        }
        
        self.config = config
        self.state = state
        
        super.init(json: json)
    }
}

public func ==(lhs: PresenceSensor, rhs: PresenceSensor) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.name == rhs.name &&
        lhs.state == rhs.state &&
        lhs.config == rhs.config &&
        lhs.type == rhs.type &&
        lhs.modelId == rhs.modelId &&
        lhs.manufacturerName == rhs.manufacturerName &&
        lhs.swVersion == rhs.swVersion
}
