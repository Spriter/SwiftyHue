//
//  Humidity.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class HumiditySensor: Sensor {
    
    public typealias AssociatedBridgeResourceType = HumiditySensor
    
    required public init?(json: JSON) {
        super.init(json: json)
    }
}