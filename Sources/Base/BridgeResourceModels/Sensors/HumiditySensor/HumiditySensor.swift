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

public func ==(lhs: HumiditySensor, rhs: HumiditySensor) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.name == rhs.name &&
        lhs.state == rhs.state &&
        lhs.config == rhs.config &&
        lhs.type == rhs.type &&
        lhs.modelId == rhs.modelId &&
        lhs.manufacturerName == rhs.manufacturerName &&
        lhs.swVersion == rhs.swVersion
}