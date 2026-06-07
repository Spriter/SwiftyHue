//
//  SensorConfig.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation

public enum SensorAlertMode {
    case unknown
    case none
    case select
    case lSelect
}

public class PartialSensorConfig {

    public var on: Bool
    public var reachable: Bool?
    public var battery: Int?
    public var url: String?

    init(on: Bool, reachable: Bool?, battery: Int?, url: String?) {
        self.on = on
        self.reachable = reachable
        self.battery = battery
        self.url = url
    }

    required public init?(json: [String: Any]) {
        guard let on = json["on"] as? Bool else {
            print("Can't create SensorConfig, missing required attribute \"on\" in JSON:\n \(json)")
            return nil
        }

        self.on = on
        self.reachable = json["reachable"] as? Bool
        self.battery = json["battery"] as? Int
        self.url = json["url"] as? String
    }

    public func toJSON() -> [String: Any]? {
        var json: [String: Any] = ["on": on]
        if let reachable { json["reachable"] = reachable }
        if let battery { json["battery"] = battery }
        if let url { json["url"] = url }
        return json
    }
}

public class SensorConfig: PartialSensorConfig {

    public var long: String?
    public var lat: String?
    public var sunriseOffset: Int?
    public var sunsetOffset: Int?

    public var tholddark: Int?
    public var tholdoffset: Int?

    init(on: Bool, reachable: Bool?, battery: Int?, url: String?, long: String?, lat: String?, sunriseOffset: Int?, sunsetOffset: Int?, tholddark: Int?, tholdoffset: Int?) {
        self.long = long
        self.lat = lat
        self.sunriseOffset = sunriseOffset
        self.sunsetOffset = sunsetOffset
        self.tholddark = tholddark
        self.tholdoffset = tholdoffset
        super.init(on: on, reachable: reachable, battery: battery, url: url)
    }

    required public init?(json: [String: Any]) {
        self.long = json["long"] as? String
        self.lat = json["lat"] as? String
        self.sunriseOffset = json["sunriseoffset"] as? Int
        self.sunsetOffset = json["sunsetoffset"] as? Int
        self.tholddark = json["tholddark"] as? Int
        self.tholdoffset = json["tholdoffset"] as? Int
        super.init(json: json)
    }

    public override func toJSON() -> [String: Any]? {
        guard var json = super.toJSON() else { return nil }
        if let long { json["long"] = long }
        if let lat { json["lat"] = lat }
        if let sunriseOffset { json["sunriseoffset"] = sunriseOffset }
        if let sunsetOffset { json["sunsetoffset"] = sunsetOffset }
        if let tholddark { json["tholddark"] = tholddark }
        if let tholdoffset { json["tholdoffset"] = tholdoffset }
        return json
    }
}

extension SensorConfig: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(1)
    }
}

public func ==(lhs: SensorConfig, rhs: SensorConfig) -> Bool {
    return lhs.on == rhs.on &&
        lhs.reachable == rhs.reachable &&
        lhs.battery == rhs.battery &&
        lhs.url == rhs.url &&
        lhs.long == rhs.long &&
        lhs.lat == rhs.lat &&
        lhs.sunriseOffset == rhs.sunriseOffset &&
        lhs.sunsetOffset == rhs.sunsetOffset &&
        lhs.tholddark == rhs.tholddark &&
        lhs.tholdoffset == rhs.tholdoffset
}
