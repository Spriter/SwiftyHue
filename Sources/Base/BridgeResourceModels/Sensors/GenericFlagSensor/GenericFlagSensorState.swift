//
//  GenericFlagSensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation

public class GenericFlagSensorState: PartialSensorState {

    public let flag: Bool

    init?(state: SensorState) {

        guard let flag: Bool = state.flag else {
            print("Can\'t create GenericFlagSensorState, missing required attribute \"flag\""); return nil
        }

        self.flag = flag

        super.init(lastUpdated: state.lastUpdated)
    }

    required public init?(json: [String: Any]) {
        guard let flag: Bool = json["flag"] as? Bool else {
            print("Can't create GenericFlagSensorState, missing required attribute \"flag\" in JSON:\n \(json)"); return nil
        }

        self.flag = flag

        super.init(json: json)
    }

    public override func toJSON() -> [String: Any]? {

        var superJson = super.toJSON() ?? [:]
        superJson["flag"] = self.flag
        return superJson
    }
}

public func ==(lhs: GenericFlagSensorState, rhs: GenericFlagSensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated &&
        lhs.flag == rhs.flag
}
