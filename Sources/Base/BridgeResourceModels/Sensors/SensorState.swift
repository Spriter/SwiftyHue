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
    case BUTTON_1 = 34
    /**
     Tap Button 2
     */
    case BUTTON_2 = 16
    /**
     Tap Button 3
     */
    case BUTTON_3 = 17
    /**
     Tap Button 4
     */
    case BUTTON_4 = 18
    /**
     INITIAL_PRESS Button 1 (ON)
     */
    case INITIAL_PRESS_BUTTON_1 = 1000
    /**
     HOLD Button 1 (ON)
     */
    case HOLD_BUTTON_1 = 1001
    /**
     SHORT_RELEASED Button 1
     */
    case SHORT_RELEASED_BUTTON_1 = 1002
    /**
     LONG_RELEASED Button 1
     */
    case LONG_RELEASED_BUTTON_1 = 1003
    /**
     INITIAL_PRESS Button 2 (ON)
     */
    case INITIAL_PRESS_BUTTON_2 = 2000
    /**
     HOLD Button 2 (ON)
     */
    case HOLD_BUTTON_2 = 2001
    /**
     SHORT_RELEASED Button 2
     */
    case SHORT_RELEASED_BUTTON_2 = 2002
    /**
     LONG_RELEASED Button 2
     */
    case LONG_RELEASED_BUTTON_2 = 2003
    /**
     INITIAL_PRESS Button 3 (ON)
     */
    case INITIAL_PRESS_BUTTON_3 = 3000
    /**
     HOLD Button 3 (ON)
     */
    case HOLD_BUTTON_3 = 3001
    /**
     SHORT_RELEASED Button 3
     */
    case SHORT_RELEASED_BUTTON_3 = 3002
    /**
     LONG_RELEASED Button 3
     */
    case LONG_RELEASED_BUTTON_3 = 3003
    /**
     INITIAL_PRESS Button 4 (ON)
     */
    case INITIAL_PRESS_BUTTON_4 = 4000
    /**
     HOLD Button 4 (ON)
     */
    case HOLD_BUTTON_4 = 4001
    /**
     SHORT_RELEASED Button 4
     */
    case SHORT_RELEASED_BUTTON_4 = 4002
    /**
     LONG_RELEASED Button 4
     */
    case LONG_RELEASED_BUTTON_4 = 4003
}

public func ==(lhs: PartialSensorState, rhs: PartialSensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated
}

public class PartialSensorState: Decodable, Encodable, Equatable {
    
    public let lastUpdated: NSDate?
    
    init(lastUpdated: NSDate?) {
        self.lastUpdated = lastUpdated
    }
    
    required public init?(json: JSON) {
        
        let dateFormatter = NSDateFormatter.hueApiDateFormatter
        
        lastUpdated = Decoder.decodeDate("lastupdated", dateFormatter:dateFormatter)(json)
    }
    
    public func toJSON() -> JSON? {
        
        let dateFormatter = NSDateFormatter.hueApiDateFormatter
        
        let json = jsonify([
            Encoder.encodeDate("lastupdated", dateFormatter: dateFormatter)(lastUpdated)
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
    
    required public init?(json: JSON) {
        
        daylight = "daylight" <~~ json
        flag = "flag" <~~ json
        status = "status" <~~ json
        humidity = "humidity" <~~ json
        open = "open" <~~ json
        presence = "presence" <~~ json
        buttonEvent = "buttonevent" <~~ json
        temperature = "temperature" <~~ json
        
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
            "temperature" ~~> temperature
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
            lhs.temperature == rhs.temperature
    
}