//
//  DaylightSensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class DaylightSensorState: SensorState {

    public let daylight: Bool
    
    required public init?(json: JSON) {
        
        guard let daylight: Bool = "daylight" <~~ json
            
            else { return nil }
        
        self.daylight = daylight
        
        super.init(json: json)
    }
}
