//
//  OpenCloseSensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation

public class OpenCloseSensorState: PartialSensorState {

    public let open: Bool

    init?(state: SensorState) {

        guard let open: Bool = state.open else {
            print("Can\'t create OpenCloseSensorState, missing required attribute \"open\""); return nil
        }

        self.open = open

        super.init(lastUpdated: state.lastUpdated)
    }

    required public init?(json: [String: Any]) {
        guard let open: Bool = json["open"] as? Bool else {
            print("Can't create OpenCloseSensorState, missing required attribute \"open\" in JSON:\n \(json)"); return nil
        }

        self.open = open

        super.init(json: json)
    }

    public override func toJSON() -> [String: Any]? {

        var superJson = super.toJSON() ?? [:]
        superJson["open"] = self.open
        return superJson
    }
}

public func ==(lhs: OpenCloseSensorState, rhs: OpenCloseSensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated &&
        lhs.open == rhs.open
}
