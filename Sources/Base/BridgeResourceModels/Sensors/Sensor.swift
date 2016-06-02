//
//  Sensor.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public enum SensorType: String {
    case ZGPSwitch, ZLLSwitch, ClipSwitch = "Clip Switch", CLIPOpenClose, CLIPPresence, CLIPTemperature, CLIPHumidity, Daylight, CLIPGenericFlag, CLIPGenericStatus
}

public class Sensor: BridgeResource, BridgeResourceDictGenerator {
    
    public typealias AssociatedBridgeResourceType = Sensor
    
    public var resourceType: BridgeResourceType {
        return .sensor
    };
    
    public let identifier: String
    public let name: String
    public let state: SensorState
    public let config: SensorConfig
    public let type: SensorType
    public let modelId: String
    public let manufacturerName: String
    public let swVersion: String
    
    public required init?(json: JSON) {
        
        let dateFormatter = NSDateFormatter.hueApiDateFormatter
        
        guard let identifier: String = "id" <~~ json,
            let name: String = "name" <~~ json,
            let state: SensorState = "state" <~~ json,
            let config: SensorConfig = "config" <~~ json,
            let type: SensorType = "type" <~~ json,
            let modelId: String = "modelid" <~~ json,
            let manufacturerName: String = "manufacturername" <~~ json,
            let swVersion: String = "swversion" <~~ json
        
        else { Log.error("Can't create Sensor from JSON:\n \(json)"); return nil }
        
        self.identifier = identifier
        self.name = name
        self.state = state
        self.config = config
        self.type = type
        self.modelId = modelId
        self.manufacturerName = manufacturerName
        self.swVersion = swVersion
    }
    
    public func toJSON() -> JSON? {
        
        let dateFormatter = NSDateFormatter.hueApiDateFormatter
        
        var json = jsonify([
            "id" ~~> identifier,
            "name" ~~> name,
            "state" ~~> state,
            "config" ~~> config,
            "type" ~~> type.rawValue,
            "modelid" ~~> modelId,
            "manufacturername" ~~> manufacturerName,
            "swversion" ~~> swVersion
            ])
        
        return json
    }
}

extension Sensor: Hashable {
    
    public var hashValue: Int {
        
        return 1
    }
}

public func ==(lhs: Sensor, rhs: Sensor) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.name == rhs.name &&
        lhs.state == rhs.state &&
        lhs.config == rhs.config &&
        lhs.type == rhs.type &&
        lhs.modelId == rhs.modelId &&
        lhs.manufacturerName == rhs.manufacturerName &&
        lhs.swVersion == rhs.swVersion
}