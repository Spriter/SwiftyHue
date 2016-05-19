//
//  SwitchSensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class SwitchSensorState: SensorState {

    required public init?(json: JSON) {
        super.init(json: json)
    }
}

public func ==(lhs: SwitchSensorState, rhs: SwitchSensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated
}