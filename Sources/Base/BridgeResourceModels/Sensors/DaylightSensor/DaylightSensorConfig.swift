//
//  DaylightSensorConfig.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation

public class DaylightSensorConfig: SensorConfig {

    required public init?(sensorConfig: SensorConfig) {
        super.init(on: sensorConfig.on, reachable: sensorConfig.reachable, battery: sensorConfig.battery, url: sensorConfig.url, long: sensorConfig.long, lat: sensorConfig.lat, sunriseOffset: sensorConfig.sunriseOffset, sunsetOffset: sensorConfig.sunsetOffset, tholddark: sensorConfig.tholddark, tholdoffset: sensorConfig.tholdoffset)
    }

    required public init?(json: [String: Any]) {
        super.init(json: json)
    }

    public override func toJSON() -> [String: Any]? {
        var superJson = super.toJSON() ?? [:]
        if let long { superJson["long"] = long }
        if let lat { superJson["lat"] = lat }
        if let sunriseOffset { superJson["sunriseoffset"] = sunriseOffset }
        if let sunsetOffset { superJson["sunsetoffset"] = sunsetOffset }
        return superJson
    }
}

public func ==(lhs: DaylightSensorConfig, rhs: DaylightSensorConfig) -> Bool {
    return lhs.on == rhs.on &&
        lhs.reachable == rhs.reachable &&
        lhs.battery == rhs.battery &&
        lhs.url == rhs.url &&
        lhs.long == rhs.long &&
        lhs.lat == rhs.lat &&
        lhs.sunriseOffset == rhs.sunriseOffset &&
        lhs.sunsetOffset == rhs.sunsetOffset
}
