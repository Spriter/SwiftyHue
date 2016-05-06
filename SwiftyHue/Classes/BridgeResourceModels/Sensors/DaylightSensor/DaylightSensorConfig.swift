//
//  DaylightSensorConfig.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class DaylightSensorConfig: SensorConfig {
    
    public let long: String
    public let lat: String
    public let sunriseOffset: Int8
    public let sunsetOffset: Int8
    
    required public init?(json: JSON) {
        
        guard let long: String = "long" <~~ json,
            let lat: String = "lat" <~~ json,
            let sunriseOffset: Int8 = "sunriseOffset" <~~ json,
            let sunsetOffset: Int8 = "sunsetOffset" <~~ json
            
            else { return nil }
        
        self.long = long
        self.lat = lat
        self.sunriseOffset = sunriseOffset
        self.sunsetOffset = sunsetOffset
        
        super.init(json: json)
    }
}
