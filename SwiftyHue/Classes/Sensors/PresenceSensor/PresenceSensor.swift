//
//  PresenceSensor.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class PresenceSensor: Sensor {
    
    public typealias AssociatedBridgeResourceType = PresenceSensor
    
    required public init?(json: JSON) {
        super.init(json: json)
    }
}