//
//  LightState.swift
//  Pods
//
//  Created by Marcel Dittmann on 21.04.16.
//
//

import Foundation

public struct LightState: Codable {

    /**
     The on off status to set the light to.
     true means on, false means off.
     */
    public var on: Bool?

    /**
     The brightness to set the light to.
     Range: 0 (lowest brightness, but not off) to 254 (highest brightness).
     */
    public var brightness: Int?

    /**
     The hue to set the light to, representing a color.
     Range: 0 - 65535 (which represents 0-360 degrees)
     Explanation: http://en.wikipedia.org/wiki/Hue
     */
    public var hue: Int?

    /**
     The saturation to set the light to.
     Range: 0 (least saturated, white) - 254 (most saturated, vivid).
     */
    public var saturation: Int?

    public var xy: [Double]?

    /**
     The colortemperature to set the light to in Mirek
     Range of 2012 hue bulb: 153 (coldest white) - 500 (warmest white)
     Range of 2014 tone light module: 153 (coldest white) - 454 (warmest white)
     Explanation: http://en.wikipedia.org/wiki/Mired
     */
    public var ct: Int?
    public var alert: String?
    public var effect: String?
    public var colormode: String?
    public var reachable: Bool?
    public var transitiontime: Int?

    enum CodingKeys: String, CodingKey {
        case on
        case brightness = "bri"
        case hue
        case saturation = "sat"
        case xy
        case ct
        case alert
        case effect
        case colormode
        case reachable
        case transitiontime
    }

    public init() {}
}

extension LightState: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.brightness ?? 0)
        hasher.combine(self.hue ?? 0)
        hasher.combine(self.saturation ?? 0)
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


public extension LightState {
    func toJSON() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let object = try? JSONSerialization.jsonObject(with: data),
              let json = object as? [String: Any] else { return nil }
        return json
    }
}


public extension LightState {
    init?(json: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: json),
              let decoded = try? JSONDecoder().decode(LightState.self, from: data) else { return nil }
        self = decoded
    }
}
