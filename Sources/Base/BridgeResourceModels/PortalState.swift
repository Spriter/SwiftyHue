//
//  PortalState.swift
//  Pods
//
//  Created by Marcel Dittmann on 22.04.16.
//
//

import Foundation

public enum PortalStateCommunication: String, Codable {
    case connected, connecting, disconnected, unknown
}

public struct PortalState: Codable {

    /**
     The bridge is signed on the portal
     */
    public let signedon: Bool?

    /**
     The bridge is able to send messages to the portal
     */
    public let incoming: Bool?

    /**
     The bridge is able to recieve messages from the portal
     */
    public let outgoing: Bool?

    /**
     The bridge is communicating with SmartPortal
     */
    public let communication: PortalStateCommunication?

    public init?(json: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: json),
              let decoded = try? JSONDecoder().decode(PortalState.self, from: data) else {
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

extension PortalState: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(1)
    }
}

public func ==(lhs: PortalState, rhs: PortalState) -> Bool {
    return lhs.signedon == rhs.signedon &&
        lhs.incoming == rhs.incoming &&
        lhs.outgoing == rhs.outgoing &&
        lhs.communication == rhs.communication
}
