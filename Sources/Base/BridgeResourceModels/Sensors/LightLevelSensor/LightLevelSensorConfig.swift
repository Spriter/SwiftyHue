//
//  LightLevelSensorConfig.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation

public class LightLevelSensorConfig: SensorConfig {

    required public init?(sensorConfig: SensorConfig) {

        guard let tholddark = sensorConfig.tholddark else {
            print("Can't create LightLevelSensorConfig, missing required attribute \"tholddark\"")
            return nil
        }

        guard let tholdoffset = sensorConfig.tholdoffset else {
            print("Can't create LightLevelSensorConfig, missing required attribute \"tholdoffset\"")
            return nil
        }

        super.init(on: sensorConfig.on, reachable: sensorConfig.reachable, battery: sensorConfig.battery, url: sensorConfig.url, long: sensorConfig.long, lat: sensorConfig.lat, sunriseOffset: sensorConfig.sunriseOffset, sunsetOffset: sensorConfig.sunsetOffset, tholddark: tholddark, tholdoffset: tholdoffset)
    }

    required public init?(json: [String: Any]) {

        guard json["tholddark"] is Int else {
            print("Can't create LightLevelSensorConfig, missing required attribute \"tholddark\" in JSON:\n \(json)")
            return nil
        }

        guard json["tholdoffset"] is Int else {
            print("Can't create LightLevelSensorConfig, missing required attribute \"tholdoffset\" in JSON:\n \(json)")
            return nil
        }

        super.init(json: json)
    }

    public override func toJSON() -> [String: Any]? {

        var superJson = super.toJSON() ?? [:]
        superJson["tholddark"] = tholddark
        superJson["tholdoffset"] = tholdoffset
        return superJson
    }
}

public func ==(lhs: LightLevelSensorConfig, rhs: LightLevelSensorConfig) -> Bool {
    return lhs.on == rhs.on &&
        lhs.reachable == rhs.reachable &&
        lhs.battery == rhs.battery &&
        lhs.url == rhs.url &&
        lhs.tholddark == rhs.tholddark &&
        lhs.tholdoffset == rhs.tholdoffset
}
