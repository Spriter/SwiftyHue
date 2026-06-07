//
//  SensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation

public enum ButtonEvent: Int {
    case button_1 = 34
    case button_2 = 16
    case button_3 = 17
    case button_4 = 18
    case initial_PRESS_BUTTON_1 = 1000
    case hold_BUTTON_1 = 1001
    case short_RELEASED_BUTTON_1 = 1002
    case long_RELEASED_BUTTON_1 = 1003
    case initial_PRESS_BUTTON_2 = 2000
    case hold_BUTTON_2 = 2001
    case short_RELEASED_BUTTON_2 = 2002
    case long_RELEASED_BUTTON_2 = 2003
    case initial_PRESS_BUTTON_3 = 3000
    case hold_BUTTON_3 = 3001
    case short_RELEASED_BUTTON_3 = 3002
    case long_RELEASED_BUTTON_3 = 3003
    case initial_PRESS_BUTTON_4 = 4000
    case hold_BUTTON_4 = 4001
    case short_RELEASED_BUTTON_4 = 4002
    case long_RELEASED_BUTTON_4 = 4003
}

public func ==(lhs: PartialSensorState, rhs: PartialSensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated
}

public class PartialSensorState: Equatable {

    public let lastUpdated: Date?

    init(lastUpdated: Date?) {
        self.lastUpdated = lastUpdated
    }

    required public init?(json: [String: Any]) {
        let dateFormatter = DateFormatter.hueApiDateFormatter
        if let lastUpdatedString = json["lastupdated"] as? String {
            lastUpdated = dateFormatter.date(from: lastUpdatedString)
        } else {
            lastUpdated = nil
        }
    }

    public func toJSON() -> [String: Any]? {
        var json: [String: Any] = [:]
        if let lastUpdated {
            json["lastupdated"] = DateFormatter.hueApiDateFormatter.string(from: lastUpdated)
        }
        return json
    }
}

public class SensorState: PartialSensorState {

    public let daylight: Bool?
    public let flag: Bool?
    public let status: Int?
    public let humidity: Int?
    public let open: Bool?
    public let presence: Bool?
    public let buttonEvent: ButtonEvent?
    public let temperature: Int?
    public let lightlevel: Int?
    public let dark: Bool?

    required public init?(json: [String: Any]) {
        daylight = json["daylight"] as? Bool
        flag = json["flag"] as? Bool
        status = json["status"] as? Int
        humidity = json["humidity"] as? Int
        open = json["open"] as? Bool
        presence = json["presence"] as? Bool
        if let raw = json["buttonevent"] as? Int {
            buttonEvent = ButtonEvent(rawValue: raw)
        } else {
            buttonEvent = nil
        }
        temperature = json["temperature"] as? Int
        lightlevel = json["lightlevel"] as? Int
        dark = json["dark"] as? Bool

        super.init(json: json)
    }

    public override func toJSON() -> [String: Any]? {
        var json = super.toJSON() ?? [:]
        if let daylight { json["daylight"] = daylight }
        if let flag { json["flag"] = flag }
        if let status { json["status"] = status }
        if let humidity { json["humidity"] = humidity }
        if let open { json["open"] = open }
        if let presence { json["presence"] = presence }
        if let buttonEvent { json["buttonevent"] = buttonEvent.rawValue }
        if let temperature { json["temperature"] = temperature }
        if let lightlevel { json["lightlevel"] = lightlevel }
        if let dark { json["dark"] = dark }
        return json
    }
}

public func ==(lhs: SensorState, rhs: SensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated &&
            lhs.daylight == rhs.daylight &&
            lhs.flag == rhs.flag &&
            lhs.status == rhs.status &&
            lhs.open == rhs.open &&
            lhs.presence == rhs.presence &&
            lhs.buttonEvent == rhs.buttonEvent &&
            lhs.temperature == rhs.temperature &&
            lhs.lightlevel == rhs.lightlevel &&
            lhs.dark == rhs.dark
}
