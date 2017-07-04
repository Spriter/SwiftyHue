//
//  SwitchSensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss


public class SwitchSensorState: PartialSensorState {

    public let buttonEvent: ButtonEvent?
    
    init?(state: SensorState) {
        
//        guard let buttonEvent: ButtonEvent = state.buttonEvent else {
//            Log.error("Can't create SwitchSensorState, missing required attribute \"buttonevent\""); return nil
//        }
        
        self.buttonEvent = state.buttonEvent
        
        super.init(lastUpdated: state.lastUpdated)
    }
    
    required public init?(json: JSON) {
        
//        guard let buttonEvent: ButtonEvent = "buttonevent" <~~ json else {
//            Log.error("Can't create SwitchSensorState, missing required attribute \"buttonevent\" in JSON:\n \(json)"); return nil
//        }
        
        self.buttonEvent = "buttonevent" <~~ json
        
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