//
//  SoftwareUpdateStatusDeviceTypes.swift
//  Pods
//
//  Created by Marcel Dittmann on 22.04.16.
//
//

import Foundation

public struct SoftwareUpdateStatusDeviceTypes: Codable {

    /**
     Flag for when bridge update is avaliable
     */
    public let bridge: Bool?

    /**
     List of IDs of lights to be updated.
     */
    public let lights: [String]?

    /**
     List of IDs of sensors to be updated
     */
    public let sensors: [String]?

    public init?(json: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: json),
              let decoded = try? JSONDecoder().decode(SoftwareUpdateStatusDeviceTypes.self, from: data) else {
            return nil
        }
        self = decoded
    }

    public func toJSON() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let object = try? JSONSerialization.jsonObject(with: data),
              let json = object as? [String: Any] else {
            return nil
        }
        return json
    }
}

extension SoftwareUpdateStatusDeviceTypes: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(1)
    }
}

public func ==(lhs: SoftwareUpdateStatusDeviceTypes, rhs: SoftwareUpdateStatusDeviceTypes) -> Bool {
    return (lhs.bridge ?? false) == (rhs.bridge ?? false) &&
        (lhs.lights ?? []) == (rhs.lights ?? []) &&
        (lhs.sensors ?? []) == (rhs.sensors ?? [])
}
