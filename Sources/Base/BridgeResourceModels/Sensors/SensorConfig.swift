//
//  SensorConfig.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public enum SensorAlertMode {
    case unknown, // It is unkown what the current alert value is
        none, // No alert active
        select, // Select alert (1 indication cycle) is active
        lSelect // Select alert (30 seconds of indication cycles) is active
}

public class PartialSensorConfig: JSONDecodable {

    public var on: Bool
    public var reachable: Bool?
    public var battery: Int?
    public var url: String?
    
    init(on: Bool, reachable: Bool?, battery: Int?, url: String?) {
        
        self.on = on
        self.reachable = reachable
        self.battery = battery
        self.url = url
    }
    
    required public init?(json: JSON) {
        
        guard let on: Bool = "on" <~~ json else {
            print("Can't create SensorConfig, missing required attribute \"on\" in JSON:\n \(json)"); return nil
        }
        
        self.on = on
        self.reachable = "reachable" <~~ json
        self.battery = "battery" <~~ json
        self.url = "url" <~~ json
        
    }
    
    public func toJSON() -> JSON? {
        
        let json = jsonify([
            "on" ~~> on,
            "reachable" ~~> reachable,
            "battery" ~~> battery,
            "url" ~~> url
            ])
        
        return json
    }
}

public class SensorConfig: PartialSensorConfig {
    
    // DaylightSensorConfig
    public let long: String?
    public let lat: String?
    public let sunriseOffset: Int?
    public let sunsetOffset: Int?
    
    // LightlevelSensorConfig
    public let tholddark: Int?
    public let tholdoffset: Int?
    
    required public init?(json: JSON) {
        
        long = "long" <~~ json
        lat = "lat" <~~ json
        sunriseOffset = "sunriseoffset" <~~ json
        sunsetOffset = "sunsetoffset" <~~ json
        tholddark = "tholddark" <~~ json
        tholdoffset = "tholdoffset" <~~ json

        super.init(json: json)
    }
    
    public override func toJSON() -> JSON? {
        
        let json = jsonify([
            "on" ~~> on,
            "reachable" ~~> reachable,
            "battery" ~~> battery,
            "url" ~~> url,
            "long" ~~> long,
            "lat" ~~> lat,
            "sunriseoffset" ~~> sunriseOffset,
            "sunsetoffset" ~~> sunsetOffset,
            "tholddark" ~~> tholddark,
            "tholdoffset" ~~> tholdoffset
            ])
        
        return json
    }
}


extension SensorConfig: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(1)
    }
}

public func ==(lhs: SensorConfig, rhs: SensorConfig) -> Bool {
    return lhs.on == rhs.on &&
        lhs.reachable == rhs.reachable &&
        lhs.battery == rhs.battery &&
        lhs.url == rhs.url &&
        lhs.long == rhs.long &&
        lhs.lat == rhs.lat &&
        lhs.sunriseOffset == rhs.sunriseOffset &&
        lhs.sunsetOffset == rhs.sunsetOffset &&
        lhs.tholddark == rhs.tholddark &&
        lhs.tholdoffset == rhs.tholdoffset
}
