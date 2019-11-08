//
//  SensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public enum ButtonEvent: Int {
    /**
     Tap Button 1
     */
    case button_1 = 34
    /**
     Tap Button 2
     */
    case button_2 = 16
    /**
     Tap Button 3
     */
    case button_3 = 17
    /**
     Tap Button 4
     */
    case button_4 = 18
    /**
     INITIAL_PRESS Button 1 (ON)
     */
    case initial_PRESS_BUTTON_1 = 1000
    /**
     HOLD Button 1 (ON)
     */
    case hold_BUTTON_1 = 1001
    /**
     SHORT_RELEASED Button 1
     */
    case short_RELEASED_BUTTON_1 = 1002
    /**
     LONG_RELEASED Button 1
     */
    case long_RELEASED_BUTTON_1 = 1003
    /**
     INITIAL_PRESS Button 2 (ON)
     */
    case initial_PRESS_BUTTON_2 = 2000
    /**
     HOLD Button 2 (ON)
     */
    case hold_BUTTON_2 = 2001
    /**
     SHORT_RELEASED Button 2
     */
    case short_RELEASED_BUTTON_2 = 2002
    /**
     LONG_RELEASED Button 2
     */
    case long_RELEASED_BUTTON_2 = 2003
    /**
     INITIAL_PRESS Button 3 (ON)
     */
    case initial_PRESS_BUTTON_3 = 3000
    /**
     HOLD Button 3 (ON)
     */
    case hold_BUTTON_3 = 3001
    /**
     SHORT_RELEASED Button 3
     */
    case short_RELEASED_BUTTON_3 = 3002
    /**
     LONG_RELEASED Button 3
     */
    case long_RELEASED_BUTTON_3 = 3003
    /**
     INITIAL_PRESS Button 4 (ON)
     */
    case initial_PRESS_BUTTON_4 = 4000
    /**
     HOLD Button 4 (ON)
     */
    case hold_BUTTON_4 = 4001
    /**
     SHORT_RELEASED Button 4
     */
    case short_RELEASED_BUTTON_4 = 4002
    /**
     LONG_RELEASED Button 4
     */
    case long_RELEASED_BUTTON_4 = 4003
}

public func ==(lhs: PartialSensorState, rhs: PartialSensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated
}

public class PartialSensorState: JSONDecodable, Equatable {
    
    public let lastUpdated: Date?
    
    init(lastUpdated: Date?) {
        self.lastUpdated = lastUpdated
    }
    
    required public init?(json: JSON) {
        
        let dateFormatter = DateFormatter.hueApiDateFormatter
        
        lastUpdated = Decoder.decode(dateForKey: "lastupdated", dateFormatter: dateFormatter)(json)
    }
    
    public func toJSON() -> JSON? {
        
        let dateFormatter = DateFormatter.hueApiDateFormatter
        
        let json = jsonify([
            Encoder.encode(dateForKey: "lastupdated", dateFormatter: dateFormatter)(lastUpdated)
            ])
        
        return json
    }
}

public class SensorState: PartialSensorState  {
    
    // Daylight
    public let daylight: Bool?
    
    // GenericFlagSensor
    public let flag: Bool?
    
    // GenericStatusState
    public let status: Int?
    
    // HumiditySensorState
    public let humidity: Int?
    
    // OpenCloseSensorState
    public let open: Bool?
    
    // PresenceSensorState
    public let presence: Bool?
    
    // SwitchSensorState
    public let buttonEvent: ButtonEvent?
    
    // TemperatureSensorState
    public let temperature: Int?
    
    // LightlevelSensorState
    public let lightlevel: Int?
    public let dark: Bool?
    
    required public init?(json: JSON) {
        
        daylight = "daylight" <~~ json
        flag = "flag" <~~ json
        status = "status" <~~ json
        humidity = "humidity" <~~ json
        open = "open" <~~ json
        presence = "presence" <~~ json
        buttonEvent = "buttonevent" <~~ json
        temperature = "temperature" <~~ json
        lightlevel = "lightlevel" <~~ json
        dark = "dark" <~~ json
        
        super.init(json: json)
    }
    
    public override func toJSON() -> JSON? {
        
        let json = jsonify([
            "daylight" ~~> daylight,
            "flag" ~~> flag,
            "status" ~~> status,
            "humidity" ~~> humidity,
            "open" ~~> open,
            "presence" ~~> presence,
            "buttonevent" ~~> buttonEvent,
            "temperature" ~~> temperature,
            "lightlevel" ~~> lightlevel,
            "dark" ~~> dark
            ])
        
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
