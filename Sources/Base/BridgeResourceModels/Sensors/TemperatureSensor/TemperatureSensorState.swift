//
//  TemperatureSensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation

public class TemperatureSensorState: PartialSensorState {

    public let temperature: Int

    init?(state: SensorState) {

        guard let temperature: Int = state.temperature else {
            print("Can\'t create TemperatureSensorState, missing required attribute \"temperature\""); return nil
        }

        self.temperature = temperature

        super.init(lastUpdated: state.lastUpdated)
    }

    required public init?(json: [String: Any]) {
        guard let temperature: Int = json["temperature"] as? Int else {
            print("Can't create TemperatureSensorState, missing required attribute \"temperature\" in JSON:\n \(json)"); return nil
        }

        self.temperature = temperature

        super.init(json: json)
    }

    public override func toJSON() -> [String: Any]? {

        var superJson = super.toJSON() ?? [:]
        superJson["temperature"] = self.temperature
        return superJson
    }
}

public func ==(lhs: TemperatureSensorState, rhs: TemperatureSensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated &&
        lhs.temperature == rhs.temperature
}
