//
//  GenericStatusSensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation

public class GenericStatusSensorState: PartialSensorState {

    public let status: Int

    init?(state: SensorState) {

        guard let status: Int = state.status else {
            print("Can\'t create GenericStatusSensorState, missing required attribute \"status\""); return nil
        }

        self.status = status

        super.init(lastUpdated: state.lastUpdated)
    }

    required public init?(json: [String: Any]) {
        guard let status: Int = json["status"] as? Int else {
            print("Can't create GenericStatusSensorState, missing required attribute \"status\" in JSON:\n \(json)"); return nil
        }

        self.status = status

        super.init(json: json)
    }

    public override func toJSON() -> [String: Any]? {

        var superJson = super.toJSON() ?? [:]
        superJson["status"] = self.status
        return superJson
    }
}

public func ==(lhs: GenericStatusSensorState, rhs: GenericStatusSensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated &&
        lhs.status == rhs.status
}
