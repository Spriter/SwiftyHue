//
//  BridgeAccessConfig.swift
//  Pods
//
//  Created by Marcel Dittmann on 06.05.16.
//
//

import Foundation

public struct BridgeAccessConfig: Codable {

    public let bridgeId: String
    public let ipAddress: String
    public let username: String

    enum CodingKeys: String, CodingKey {
        case bridgeId = "id"
        case ipAddress = "ipaddress"
        case username
    }

    public init(bridgeId: String, ipAddress: String, username: String) {
        self.bridgeId = bridgeId
        self.ipAddress = ipAddress
        self.username = username
    }
}


public extension BridgeAccessConfig {
    init?(json: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: json),
              let decoded = try? JSONDecoder().decode(BridgeAccessConfig.self, from: data) else { return nil }
        self = decoded
    }

    func toJSON() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let object = try? JSONSerialization.jsonObject(with: data),
              let json = object as? [String: Any] else { return nil }
        return json
    }
}
