//
//  GenericStatusSensor.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class GenericStatusSensor: Sensor {
    
    public typealias AssociatedBridgeResourceType = GenericStatusSensor
    
    required public init?(json: JSON) {
        super.init(json: json)
    }
}