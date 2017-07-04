//
//  DaylightSensorConfig.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class DaylightSensorConfig: PartialSensorConfig {
    
    public let long: String?
    public let lat: String?
    public let sunriseOffset: Int?
    public let sunsetOffset: Int?
    
    init?(sensorConfig: SensorConfig) {
        
//        guard let long: String = sensorConfig.long else {
//            Log.error("Can't create DaylightSensorConfig, missing required attribute \"long\""); return nil
//        }
//        
//        guard let lat: String = sensorConfig.lat else {
//            Log.error("Can't create DaylightSensorConfig, missing required attribute \"lat\""); return nil
//        }
        
        self.long = sensorConfig.long
        self.lat = sensorConfig.lat
        self.sunriseOffset = sensorConfig.sunriseOffset
        self.sunsetOffset = sensorConfig.sunsetOffset
        
        super.init(on: sensorConfig.on, reachable: sensorConfig.reachable, battery: sensorConfig.battery, url: sensorConfig.url)
    }
    
    required public init?(json: JSON) {
        
//        guard let long: String = "long" <~~ json else {
//            Log.error("Can't create DaylightSensorConfig, missing required attribute \"long\" in JSON:\n \(json)"); return nil
//        }
//        
//        guard let lat: String = "lat" <~~ json else {
//            Log.error("Can't create DaylightSensorConfig, missing required attribute \"lat\" in JSON:\n \(json)"); return nil
//        }
        
        self.long = "long" <~~ json
        self.lat = "lat" <~~ json
        self.sunriseOffset = "sunriseoffset" <~~ json
        self.sunsetOffset = "sunsetoffset" <~~ json
        
        super.init(json: json)
    }
    
    public override func toJSON() -> JSON? {
        
        if var superJson = super.toJSON() {
            let json = jsonify([
                "long" ~~> long,
                "lat" ~~> lat,
                "sunriseoffset" ~~> sunriseOffset,
                "sunsetoffset" ~~> sunsetOffset
                ])
            superJson.unionInPlace(json!)
            return superJson
        }
        
        return nil
    }
}

public func ==(lhs: DaylightSensorConfig, rhs: DaylightSensorConfig) -> Bool {
    return lhs.on == rhs.on &&
        lhs.reachable == rhs.reachable &&
        lhs.battery == rhs.battery &&
        lhs.url == rhs.url &&
        lhs.long == rhs.long &&
        lhs.lat == rhs.lat &&
        lhs.sunriseOffset == rhs.sunriseOffset &&
        lhs.sunsetOffset == rhs.sunsetOffset
}
