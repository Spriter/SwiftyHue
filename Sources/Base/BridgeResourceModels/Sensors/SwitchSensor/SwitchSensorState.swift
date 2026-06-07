//
//  SwitchSensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation

public class SwitchSensorState: PartialSensorState {

    public let buttonEvent: ButtonEvent?

    init?(state: SensorState) {
        self.buttonEvent = state.buttonEvent
        super.init(lastUpdated: state.lastUpdated)
    }

    required public init?(json: [String: Any]) {
        if let raw = json["buttonevent"] as? Int {
            self.buttonEvent = ButtonEvent(rawValue: raw)
        } else {
            self.buttonEvent = nil
        }

        super.init(json: json)
    }

    public override func toJSON() -> [String: Any]? {
        var superJson = super.toJSON() ?? [:]
        if let buttonEvent { superJson["buttonevent"] = buttonEvent.rawValue }
        return superJson
    }
}

public func ==(lhs: SwitchSensorState, rhs: SwitchSensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated &&
        lhs.buttonEvent == rhs.buttonEvent
}
