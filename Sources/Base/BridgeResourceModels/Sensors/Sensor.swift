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

public func ==(lhs: PartialSensor, rhs: PartialSensor) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.name == rhs.name &&
        lhs.type == rhs.type &&
        lhs.modelId == rhs.modelId &&
        lhs.manufacturerName == rhs.manufacturerName &&
        lhs.swVersion == rhs.swVersion
}

public class PartialSensor: BridgeResource, BridgeResourceDictGenerator, Equatable  {
    
    public typealias AssociatedBridgeResourceType = Sensor;
    
    public var resourceType: BridgeResourceType {
        return .sensor
    }
    
    public let identifier: String
    public let uniqueId: String?
    public let name: String
    public let type: SensorType
    public let modelId: String
    public let manufacturerName: String
    public let swVersion: String
    public let recycle: Bool?
    
    internal init(identifier: String, uniqueId: String?, name: String, type: SensorType, modelId: String, manufacturerName: String, swVersion: String, recycle: Bool?) {
        
        self.identifier = identifier
        self.uniqueId = uniqueId
        self.name = name
        self.type = type
        self.modelId = modelId
        self.manufacturerName = manufacturerName
        self.swVersion = swVersion
        self.recycle = recycle
    }
    
    public required init?(json: JSON) {
        
        guard let identifier: String = "id" <~~ json else {
            print("Can't create Sensor, missing required attribute \"id\" in JSON:\n \(json)"); return nil
        }
        
        //        guard let uniqueId: String = "uniqueid" <~~ json else {
        //            Log.error("Can't create Sensor, missing required attribute \"uniqueId\" in JSON:\n \(json)"); return nil
        //        }
        
        guard let name: String = "name" <~~ json else {
            print("Can't create Sensor, missing required attribute \"name\" in JSON:\n \(json)"); return nil
        }
        
        guard let type: SensorType = "type" <~~ json else {
            print("Can't create Sensor, missing required attribute \"type\" in JSON:\n \(json)"); return nil
        }
        
        guard let modelId: String = "modelid" <~~ json else {
            print("Can't create Sensor, missing required attribute \"modelid\" in JSON:\n \(json)"); return nil
        }
        
        guard let manufacturerName: String = "manufacturername" <~~ json else {
            print("Can't create Sensor, missing required attribute \"manufacturername\" in JSON:\n \(json)"); return nil
        }
        
        guard let swVersion: String = "swversion" <~~ json else {
            print("Can't create Sensor, missing required attribute \"swversion\" in JSON:\n \(json)"); return nil
        }
        
        self.uniqueId = "uniqueid" <~~ json
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
            "type" ~~> type,
            "modelid" ~~> modelId,
            "manufacturername" ~~> manufacturerName,
            "swversion" ~~> swVersion
            ])
        
        return json
    }
}

public class Sensor: PartialSensor{
    
    public typealias AssociatedBridgeResourceType = Sensor;
    
    public let state: SensorState?
    public let config: SensorConfig?
  
    public required init?(json: JSON) {
        
        self.state = "state" <~~ json
        self.config = "config" <~~ json
        
        super.init(json: json)
    }
    
    public override func toJSON() -> JSON? {
        
        let json = jsonify([
            "id" ~~> identifier,
            "uniqueid" ~~> uniqueId,
            "name" ~~> name,
            "type" ~~> type,
            "modelid" ~~> modelId,
            "manufacturername" ~~> manufacturerName,
            "swversion" ~~> swVersion,
            "state" ~~> state,
            "config" ~~> config
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

extension Sensor {
    
    public func isDaylightSensor() -> Bool {
        return type == .Daylight
    }
    
    public func isGenericFlagSensor() -> Bool {
        return type == .CLIPGenericFlag
    }

    public func isGenericStatusSensor() -> Bool {
        return type == .CLIPGenericStatus
    }
    
    public func isHumiditySensor() -> Bool {
        return type == .CLIPHumidity
    }
    
    public func isOpenCloseSensor() -> Bool {
        return type == .CLIPOpenClose
    }
    
    public func isPresenceSensor() -> Bool {
        return type == .CLIPPresence
    }
    
    public func isSwitchSensor() -> Bool {
        return type == .ZGPSwitch || type == .ZLLSwitch || type == .ClipSwitch
    }
    
    public func isTemperatureSensor() -> Bool {
        return type == .CLIPTemperature
    }
    
    public func asDaylightSensor() -> DaylightSensor? {
        return DaylightSensor(sensor: self)
    }
    
    public func asGenericFlagSensor() -> GenericFlagSensor? {
        
        return GenericFlagSensor(sensor: self)
    }

    public func asGenericStatusSensor() -> GenericStatusSensor? {
        return GenericStatusSensor(sensor: self)
    }
    
    public func asHumiditySensor() -> HumiditySensor? {
        return HumiditySensor(sensor: self)
    }
    
    public func asOpenCloseSensor() -> OpenCloseSensor? {
        return OpenCloseSensor(sensor: self)
    }
    
    public func asPresenceSensor() -> PresenceSensor? {
        return PresenceSensor(sensor: self)
    }
    
    public func asSwitchSensor() -> SwitchSensor? {
        return SwitchSensor(sensor: self)
    }
    
    public func asTemperatureSensor() -> TemperatureSensor? {
        return TemperatureSensor(sensor: self)
    }
}
