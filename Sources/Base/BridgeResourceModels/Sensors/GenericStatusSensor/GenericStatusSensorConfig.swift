//
//  GenericStatusSensorConfig.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation

public class GenericStatusSensorConfig: PartialSensorConfig {

    init?(sensorConfig: SensorConfig) {
        
        super.init(on: sensorConfig.on, reachable: sensorConfig.reachable, battery: sensorConfig.battery, url: sensorConfig.url)
    }
    
    required public init?(json: [String: Any]) {
        
        super.init(json: json)
    }
}

public func ==(lhs: GenericStatusSensorConfig, rhs: GenericStatusSensorConfig) -> Bool {
    return lhs.on == rhs.on &&
        lhs.reachable == rhs.reachable &&
        lhs.battery == rhs.battery &&
        lhs.url == rhs.url
}
