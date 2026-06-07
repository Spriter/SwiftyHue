//
//  HumiditySensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation

public class HumiditySensorState: PartialSensorState {

    public let humidity: Int

    init?(state: SensorState) {

        guard let humidity: Int = state.humidity else {
            print("Can\'t create HumiditySensorState, missing required attribute \"humidity\""); return nil
        }

        self.humidity = humidity

        super.init(lastUpdated: state.lastUpdated)
    }

    required public init?(json: [String: Any]) {
        guard let humidity: Int = json["humidity"] as? Int else {
            print("Can't create HumiditySensorState, missing required attribute \"humidity\" in JSON:\n \(json)"); return nil
        }

        self.humidity = humidity

        super.init(json: json)
    }

    public override func toJSON() -> [String: Any]? {

        var superJson = super.toJSON() ?? [:]
        superJson["humidity"] = self.humidity
        return superJson
    }
}

public func ==(lhs: HumiditySensorState, rhs: HumiditySensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated &&
        lhs.humidity == rhs.humidity
}
