//
//  LightLevelSensorConfig.swift
//  Pods
//
//  Created by Jerome Schmitz on 08.11.19.
//
//

import Foundation
import Gloss

public class LightLevelSensorConfig: PartialSensorConfig {
    
    /**
     Threshold the user configured to be used in rules to determine insufficient lightlevel (ie below threshold). Default value 16000
     */
    public let tholddark: Int
    
    /**
     Threshold the user configured to be used in rules to determine sufficient lightlevel (ie above threshold). Specified as relative offset to the “dark” threshold. Shall be >=1. Default value 7000
     */
    public let tholdoffset: Int
    
    init?(sensorConfig: SensorConfig) {
        
        guard let tholddark: Int = sensorConfig.tholddark else {
            print("Can't create LightlevelSensorConfig, missing required attribute \"tholddark\""); return nil
        }
        self.tholddark = tholddark
        
        guard let tholdoffset: Int = sensorConfig.tholdoffset else {
            print("Can't create LightlevelSensorConfig, missing required attribute \"tholdoffset\""); return nil
        }
        self.tholdoffset = tholdoffset
        
        super.init(on: sensorConfig.on, reachable: sensorConfig.reachable, battery: sensorConfig.battery, url: sensorConfig.url)
    }
    
    required public init?(json: JSON) {
        
        guard let tholddark: Int = "tholddark" <~~ json else {
            print("Can't create LightlevelSensorConfig, missing required attribute \"tholddark\""); return nil
        }
        self.tholddark = tholddark
        
        guard let tholdoffset: Int = "tholdoffset" <~~ json else {
            print("Can't create LightlevelSensorConfig, missing required attribute \"tholdoffset\""); return nil
        }
        self.tholdoffset = tholdoffset
        
        super.init(json: json)
    }
    
    public override func toJSON() -> JSON? {
        
        if var superJson = super.toJSON() {
            let json = jsonify([
                "tholddark" ~~> tholddark,
                "tholdoffset" ~~> tholdoffset
                ])
            superJson.unionInPlace(json!)
            return superJson
        }
        
        return nil
    }
}

public func ==(lhs: LightLevelSensorConfig, rhs: LightLevelSensorConfig) -> Bool {
    return lhs.on == rhs.on &&
        lhs.reachable == rhs.reachable &&
        lhs.battery == rhs.battery &&
        lhs.url == rhs.url &&
        lhs.tholddark == rhs.tholddark &&
        lhs.tholdoffset == rhs.tholdoffset
}
