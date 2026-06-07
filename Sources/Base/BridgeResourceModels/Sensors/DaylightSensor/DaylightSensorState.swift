//
//  DaylightSensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation

public class DaylightSensorState: PartialSensorState {

    public let daylight: Bool

    init?(state: SensorState) {

        guard let daylight: Bool = state.daylight else {
            print("Can\'t create DaylightSensorState, missing required attribute \"daylight\""); return nil
        }

        self.daylight = daylight

        super.init(lastUpdated: state.lastUpdated)
    }

    required public init?(json: [String: Any]) {
        guard let daylight: Bool = json["daylight"] as? Bool else {
            print("Can't create DaylightSensorState, missing required attribute \"daylight\" in JSON:\n \(json)"); return nil
        }

        self.daylight = daylight

        super.init(json: json)
    }

    public override func toJSON() -> [String: Any]? {

        var superJson = super.toJSON() ?? [:]
        superJson["daylight"] = self.daylight
        return superJson
    }
}

public func ==(lhs: DaylightSensorState, rhs: DaylightSensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated &&
        lhs.daylight == rhs.daylight
}
