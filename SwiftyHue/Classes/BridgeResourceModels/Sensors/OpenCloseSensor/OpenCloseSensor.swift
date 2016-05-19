//
//  OpenCloseSensor.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class OpenCloseSensor: Sensor {
    
    public typealias AssociatedBridgeResourceType = OpenCloseSensor
    
    required public init?(json: JSON) {
        super.init(json: json)
    }
}

public func ==(lhs: OpenCloseSensor, rhs: OpenCloseSensor) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.name == rhs.name &&
        lhs.state == rhs.state &&
        lhs.config == rhs.config &&
        lhs.type == rhs.type &&
        lhs.modelId == rhs.modelId &&
        lhs.manufacturerName == rhs.manufacturerName &&
        lhs.swVersion == rhs.swVersion
}