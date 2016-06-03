//
//  SwitchSensorState.swift
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

public class SwitchSensorState: SensorState {

    public let buttonEvent: ButtonEvent
    
    required public init?(json: JSON) {
        
        guard let buttonEvent: ButtonEvent = "buttonevent" <~~ json else {
            Log.error("Can't create SwitchSensorState, missing required attribute \"buttonevent\" in JSON:\n \(json)"); return nil
        }
        
        self.buttonEvent = buttonEvent
        
        super.init(json: json)
    }
    
    public override func toJSON() -> JSON? {
        
        if var superJson = super.toJSON() {
            let json = jsonify([
                "buttonevent" ~~> self.buttonEvent
                ])
            superJson.unionInPlace(json!)
            return superJson
        }
        
        return nil
    }
}

public func ==(lhs: SwitchSensorState, rhs: SwitchSensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated &&
        lhs.buttonEvent == rhs.buttonEvent
}