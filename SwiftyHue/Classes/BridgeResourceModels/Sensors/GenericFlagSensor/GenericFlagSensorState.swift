//
//  GenericFlagSensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class GenericFlagSensorState: SensorState {
    
    public let flag: Bool
    
    required public init?(json: JSON) {
        
        guard let flag: Bool = "flag" <~~ json
            
            else { return nil }
        
        self.flag = flag
        
        super.init(json: json)
    }
}