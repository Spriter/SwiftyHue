//
//  PresenceSensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation

public class PresenceSensorState: PartialSensorState {

    public let presence: Bool

    init?(state: SensorState) {

        guard let presence: Bool = state.presence else {
            print("Can\'t create PresenceSensorState, missing required attribute \"presence\""); return nil
        }

        self.presence = presence

        super.init(lastUpdated: state.lastUpdated)
    }

    required public init?(json: [String: Any]) {
        guard let presence: Bool = json["presence"] as? Bool else {
            print("Can't create PresenceSensorState, missing required attribute \"presence\" in JSON:\n \(json)"); return nil
        }

        self.presence = presence

        super.init(json: json)
    }

    public override func toJSON() -> [String: Any]? {

        var superJson = super.toJSON() ?? [:]
        superJson["presence"] = self.presence
        return superJson
    }
}

public func ==(lhs: PresenceSensorState, rhs: PresenceSensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated &&
        lhs.presence == rhs.presence
}
