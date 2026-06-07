//
//  Sensor.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation

public enum SensorType: String {
    case ZGPSwitch, ZLLSwitch, ClipSwitch = "Clip Switch", CLIPOpenClose, CLIPPresence, ZLLPresence, CLIPTemperature, ZLLTemperature, CLIPHumidity, Daylight, CLIPGenericFlag, CLIPGenericStatus, CLIPLightLevel, ZLLLightLevel
}

public func ==(lhs: PartialSensor, rhs: PartialSensor) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.name == rhs.name &&
        lhs.type == rhs.type &&
        lhs.modelId == rhs.modelId &&
        lhs.manufacturerName == rhs.manufacturerName &&
        lhs.swVersion == rhs.swVersion
}

public class PartialSensor: BridgeResource, BridgeResourceDictGenerator, Equatable {

    public typealias AssociatedBridgeResourceType = Sensor

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

    public required init?(json: [String: Any]) {
        guard let identifier = json["id"] as? String else {
            print("Can't create Sensor, missing required attribute \"id\" in JSON:\n \(json)")
            return nil
        }

        guard let name = json["name"] as? String else {
            print("Can't create Sensor, missing required attribute \"name\" in JSON:\n \(json)")
            return nil
        }

        guard let typeRaw = json["type"] as? String,
              let type = SensorType(rawValue: typeRaw) else {
            print("Can't create Sensor, missing required attribute \"type\" in JSON:\n \(json)")
            return nil
        }

        guard let modelId = json["modelid"] as? String else {
            print("Can't create Sensor, missing required attribute \"modelid\" in JSON:\n \(json)")
            return nil
        }

        guard let manufacturerName = json["manufacturername"] as? String else {
            print("Can't create Sensor, missing required attribute \"manufacturername\" in JSON:\n \(json)")
            return nil
        }

        guard let swVersion = json["swversion"] as? String else {
            print("Can't create Sensor, missing required attribute \"swversion\" in JSON:\n \(json)")
            return nil
        }

        self.uniqueId = json["uniqueid"] as? String
        self.recycle = json["recycle"] as? Bool

        self.identifier = identifier
        self.name = name
        self.type = type
        self.modelId = modelId
        self.manufacturerName = manufacturerName
        self.swVersion = swVersion
    }

    public func toJSON() -> [String: Any]? {
        var json: [String: Any] = [
            "id": identifier,
            "name": name,
            "type": type.rawValue,
            "modelid": modelId,
            "manufacturername": manufacturerName,
            "swversion": swVersion
        ]
        if let uniqueId { json["uniqueid"] = uniqueId }
        if let recycle { json["recycle"] = recycle }
        return json
    }
}

public class Sensor: PartialSensor {

    public typealias AssociatedBridgeResourceType = Sensor

    public let state: SensorState?
    public let config: SensorConfig?

    public required init?(json: [String: Any]) {
        if let stateJson = json["state"] as? [String: Any] {
            self.state = SensorState(json: stateJson)
        } else {
            self.state = nil
        }

        if let configJson = json["config"] as? [String: Any] {
            self.config = SensorConfig(json: configJson)
        } else {
            self.config = nil
        }

        super.init(json: json)
    }

    public override func toJSON() -> [String: Any]? {
        var json = super.toJSON() ?? [:]
        if let stateJson = state?.toJSON() { json["state"] = stateJson }
        if let configJson = config?.toJSON() { json["config"] = configJson }
        return json
    }
}

extension Sensor: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(1)
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

    public func isDaylightSensor() -> Bool { type == .Daylight }
    public func isGenericFlagSensor() -> Bool { type == .CLIPGenericFlag }
    public func isGenericStatusSensor() -> Bool { type == .CLIPGenericStatus }
    public func isHumiditySensor() -> Bool { type == .CLIPHumidity }
    public func isOpenCloseSensor() -> Bool { type == .CLIPOpenClose }
    public func isPresenceSensor() -> Bool { type == .CLIPPresence || type == .ZLLPresence }
    public func isSwitchSensor() -> Bool { type == .ZGPSwitch || type == .ZLLSwitch || type == .ClipSwitch }
    public func isLightLevelSensor() -> Bool { type == .CLIPLightLevel || type == .ZLLLightLevel }
    public func isTemperatureSensor() -> Bool { type == .CLIPTemperature || type == .ZLLTemperature }

    public func asDaylightSensor() -> DaylightSensor? { DaylightSensor(sensor: self) }
    public func asGenericFlagSensor() -> GenericFlagSensor? { GenericFlagSensor(sensor: self) }
    public func asGenericStatusSensor() -> GenericStatusSensor? { GenericStatusSensor(sensor: self) }
    public func asHumiditySensor() -> HumiditySensor? { HumiditySensor(sensor: self) }
    public func asOpenCloseSensor() -> OpenCloseSensor? { OpenCloseSensor(sensor: self) }
    public func asPresenceSensor() -> PresenceSensor? { PresenceSensor(sensor: self) }
    public func asSwitchSensor() -> SwitchSensor? { SwitchSensor(sensor: self) }
    public func asTemperatureSensor() -> TemperatureSensor? { TemperatureSensor(sensor: self) }
    public func asLightlevelSensor() -> LightLevelSensor? { LightLevelSensor(sensor: self) }
}
