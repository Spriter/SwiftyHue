//
//  LightState.swift
//  Pods
//
//  Created by Marcel Dittmann on 21.04.16.
//
//

import Foundation
import Gloss

public struct LightState: JSONDecodable, JSONEncodable {
    
    /**
     The on off status to set the light to.
     true means on, false means off.
     */
    public var on: Bool?;
    
    /**
     The brightness to set the light to.
     Range: 0 (lowest brightness, but not off) to 254 (highest brightness).
     */
    public var brightness: Int?;
    
    /**
     The hue to set the light to, representing a color.
     Range: 0 - 65535 (which represents 0-360 degrees)
     Explanation: http://en.wikipedia.org/wiki/Hue
     */
    public var hue: Int?;
    
    /**
     The saturation to set the light to.
     Range: 0 (least saturated, white) - 254 (most saturated, vivid).
     */
    public var saturation: Int?;
        
    public var xy: [Float]?;
    
    /**
     The colortemperature to set the light to in Mirek
     Range of 2012 hue bulb: 153 (coldest white) - 500 (warmest white)
     Range of 2014 tone light module: 153 (coldest white) - 454 (warmest white)
     Explanation: http://en.wikipedia.org/wiki/Mired
     */
    public var ct: Int?;
    public var alert: String?;
    public var effect: String?;
    public var colormode: String?;
    public var reachable: Bool?;
    public var transitiontime: Int?;
    
    public init() {
        
    }
    
    public init?(json: JSON) {
    
        self.on = "on" <~~ json
        self.brightness = "bri" <~~ json
        self.hue = "hue" <~~ json
        self.saturation = "sat" <~~ json
        self.xy = "xy" <~~ json
        self.ct = "ct" <~~ json
        self.alert = "alert" <~~ json
        self.effect = "effect" <~~ json
        self.colormode = "colormode" <~~ json
        self.reachable = "reachable" <~~ json
        self.transitiontime = "transitiontime" <~~ json
    }
    
    public func toJSON() -> JSON? {
  
        return jsonify([
            "on" ~~> on,
            "bri" ~~> brightness,
            "hue" ~~> hue,
            "sat" ~~> saturation,
            "xy" ~~> xy,
            "ct" ~~> ct,
            "alert" ~~> alert,
            "effect" ~~> effect,
            "colormode" ~~> colormode,
            "reachable" ~~> reachable,
            "transitiontime" ~~> transitiontime

        ])
    }
}

extension LightState: Hashable {
    
    public var hashValue: Int {
        return (self.brightness ?? 0) + (self.hue ?? 0) + (self.saturation ?? 0)
    }
}

public func ==(lhs: LightState, rhs: LightState) -> Bool {
    return lhs.on == rhs.on &&
        lhs.brightness == rhs.brightness &&
        lhs.hue == rhs.hue &&
        lhs.saturation == rhs.saturation &&
        (lhs.xy ?? [-1, -1]) == (rhs.xy ?? [-1, -1]) &&
        lhs.ct == rhs.ct &&
        lhs.alert == rhs.alert &&
        lhs.effect == rhs.effect &&
        lhs.colormode == rhs.colormode &&
        lhs.reachable == rhs.reachable &&
        lhs.transitiontime == rhs.transitiontime
}
