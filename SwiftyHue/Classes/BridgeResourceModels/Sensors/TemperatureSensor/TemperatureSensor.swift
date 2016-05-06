//
//  TemperatureSensor.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class TemperatureSensor: Sensor {
    
    public typealias AssociatedBridgeResourceType = TemperatureSensor
    
    required public init?(json: JSON) {
        super.init(json: json)
    }
}