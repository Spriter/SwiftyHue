//
//  LightLevelSensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation

public class LightLevelSensorState: PartialSensorState {

    public let lightlevel: Int?
    public let dark: Bool?
    public let daylight: Bool?

    init?(state: SensorState) {
        guard let lightlevel = state.lightlevel,
              let dark = state.dark,
              let daylight = state.daylight else {
            print("Can\'t create LightLevelSensorState, missing required attributes")
            return nil
        }

        self.lightlevel = lightlevel
        self.dark = dark
        self.daylight = daylight

        super.init(lastUpdated: state.lastUpdated)
    }

    required public init?(json: [String: Any]) {
        guard let lightlevel = json["lightlevel"] as? Int else {
            print("Can\'t create LightLevelSensorState, missing required attribute \"lightlevel\" in JSON:\n \(json)"); return nil
        }
        guard let dark = json["dark"] as? Bool else {
            print("Can\'t create LightLevelSensorState, missing required attribute \"dark\" in JSON:\n \(json)"); return nil
        }
        guard let daylight = json["daylight"] as? Bool else {
            print("Can\'t create LightLevelSensorState, missing required attribute \"daylight\" in JSON:\n \(json)"); return nil
        }

        self.lightlevel = lightlevel
        self.dark = dark
        self.daylight = daylight

        super.init(json: json)
    }

    public override func toJSON() -> [String: Any]? {
        var superJson = super.toJSON() ?? [:]
        if let lightlevel { superJson["lightlevel"] = lightlevel }
        if let dark { superJson["dark"] = dark }
        if let daylight { superJson["daylight"] = daylight }
        return superJson
    }
}

public func ==(lhs: LightLevelSensorState, rhs: LightLevelSensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated &&
        lhs.lightlevel == rhs.lightlevel &&
        lhs.dark == rhs.dark &&
        lhs.daylight == rhs.daylight
}
