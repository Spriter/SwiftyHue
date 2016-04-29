//
//  LightState.swift
//  Pods
//
//  Created by Marcel Dittmann on 21.04.16.
//
//

import Foundation
import Gloss

public struct LightState: Decodable, Encodable {
    
    /**
     The on off status to set the light to.
     true means on, false means off.
     */
    public var on: Bool?;
    
    /**
     The brightness to set the light to.
     Range: 0 (lowest brightness, but not off) to 254 (highest brightness).
     */
    public var bri: Int?;
    
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
    public var sat: Int?;
        
    public var xy: [Float]?;
    
    /**
     The colortemperature to set the light to in Mirek
     Range of 2012 hue bulb: 153 (coldest white) - 500 (warmest white)
     Range of 2014 tone light module: 153 (coldest white) - 454 (warmest white)
     Explanation: http://en.wikipedia.org/wiki/Mired
     */
    public var ct: Int?;
    
    /**
    The scene identifier if the scene you wish to recall.
     */
    public var sceneIdentifier: String?
    
    public var alert: String?;
    public var effect: String?;
    public var colormode: String?;
    public var reachable: Bool?;
    
    public init() {
        
    }
    
    public init?(json: JSON) {
    
        self.on = "on" <~~ json
        self.bri = "bri" <~~ json
        self.hue = "hue" <~~ json
        self.sat = "sat" <~~ json
        self.xy = "xy" <~~ json
        self.ct = "ct" <~~ json
        self.alert = "alert" <~~ json
        self.effect = "effect" <~~ json
        self.colormode = "colormode" <~~ json
        self.reachable = "reachable" <~~ json
        self.sceneIdentifier = "scene" <~~ json
    }
    
    public func toJSON() -> JSON? {
  
        return jsonify([
            "on" ~~> self.on,
            "bri" ~~> self.bri,
            "hue" ~~> self.hue,
            "sat" ~~> self.sat,
            "xy" ~~> self.xy,
            "ct" ~~> self.ct,
            "alert" ~~> self.alert,
            "effect" ~~> self.effect,
            "colormode" ~~> self.colormode,
            "reachable" ~~> self.reachable,
            "scene" ~~> self.sceneIdentifier
    
        ])
    }
}