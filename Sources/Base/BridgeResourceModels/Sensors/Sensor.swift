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
    public let uniqueId: String?
    public let name: String
    public let type: SensorType
    public let modelId: String
    public let manufacturerName: String
    public let swVersion: String
    public let state: SensorState?
    public let config: SensorConfig?
    public let recycle: Bool?
    
    public required init?(json: JSON) {
        
        guard let identifier: String = "id" <~~ json else {
            Log.error("Can't create Sensor, missing required attribute \"id\" in JSON:\n \(json)"); return nil
        }
        
//        guard let uniqueId: String = "uniqueid" <~~ json else {
//            Log.error("Can't create Sensor, missing required attribute \"uniqueId\" in JSON:\n \(json)"); return nil
//        }
        
        guard let name: String = "name" <~~ json else {
            Log.error("Can't create Sensor, missing required attribute \"name\" in JSON:\n \(json)"); return nil
        }
        
        guard let type: SensorType = "type" <~~ json else {
            Log.error("Can't create Sensor, missing required attribute \"type\" in JSON:\n \(json)"); return nil
        }
        
        guard let modelId: String = "modelid" <~~ json else {
            Log.error("Can't create Sensor, missing required attribute \"modelid\" in JSON:\n \(json)"); return nil
        }
        
        guard let manufacturerName: String = "manufacturername" <~~ json else {
            Log.error("Can't create Sensor, missing required attribute \"manufacturername\" in JSON:\n \(json)"); return nil
        }
        
        guard let swVersion: String = "swversion" <~~ json else {
            Log.error("Can't create Sensor, missing required attribute \"swversion\" in JSON:\n \(json)"); return nil
        }
        
        self.uniqueId = "uniqueid" <~~ json
        self.state = "state" <~~ json
        self.config = "config" <~~ json
        self.recycle = "recycle" <~~ json
        
        self.identifier = identifier
        self.name = name
        self.type = type
        self.modelId = modelId
        self.manufacturerName = manufacturerName
        self.swVersion = swVersion
    }
    
    public func toJSON() -> JSON? {
        
        let json = jsonify([
            "id" ~~> identifier,
            "uniqueid" ~~> uniqueId,
            "name" ~~> name,
            "state" ~~> state,
            "config" ~~> config,
            "type" ~~> type,
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