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
    case Unknown, // It is unkown what the current alert value is
        None, // No alert active
        Select, // Select alert (1 indication cycle) is active
        LSelect // Select alert (30 seconds of indication cycles) is active
}

public class SensorConfig: Decodable, Encodable {

    public let on: Bool
    public let reachable: Bool?
    public let battery: Int8?
    public let url: String?
    
    required public init?(json: JSON) {
        
        guard let on: Bool = "on" <~~ json
            
            else { return nil }
        
        self.on = on
        self.reachable = "reachable" <~~ json
        self.battery = "battery" <~~ json
        self.url = "url" <~~ json
    }
    
    public func toJSON() -> JSON? {
        
        let dateFormatter = NSDateFormatter.hueApiDateFormatter
        
        var json = jsonify([
            "on" ~~> self.on,
            "reachable" ~~> self.reachable,
            "battery" ~~> self.battery,
            "url" ~~> self.url,
            ])
        
        return json
    }
}