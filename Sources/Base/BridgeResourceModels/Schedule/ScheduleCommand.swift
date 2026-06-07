//
//  ScheduleCommand.swift
//  Pods
//
//  Created by Jerome Schmitz on 05.05.16.
//
//

import Foundation

public class ScheduleCommand: Codable {

    public let address: String
    public let method: String
    public let body: [String: Any]

    enum CodingKeys: String, CodingKey {
        case address
        case method
        case body
    }

    public init(address: String, method: String, body: [String: Any]) {
        self.address = address
        self.method = method
        self.body = body
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        address = try container.decode(String.self, forKey: .address)
        method = try container.decode(String.self, forKey: .method)
        let bodyCodable = try container.decode([String: JSONValue].self, forKey: .body)
        body = bodyCodable.mapValues { $0.anyValue }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address, forKey: .address)
        try container.encode(method, forKey: .method)

        var bodyCodable: [String: JSONValue] = [:]
        for (key, value) in body {
            guard let converted = JSONValue(any: value) else {
                throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: [CodingKeys.body], debugDescription: "Unsupported JSON value for body key '\(key)'"))
            }
            bodyCodable[key] = converted
        }

        try container.encode(bodyCodable, forKey: .body)
    }
}

extension ScheduleCommand: Hashable {

    public func hash(into hasher: inout Hasher) {

        hasher.combine(address)
        hasher.combine(method)
    }
}

public func ==(lhs: ScheduleCommand, rhs: ScheduleCommand) -> Bool {
    return lhs.address == rhs.address &&
        lhs.method  == rhs.method
}


public extension ScheduleCommand {
    func toJSON() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let object = try? JSONSerialization.jsonObject(with: data),
              let json = object as? [String: Any] else { return nil }
        return json
    }
}


public extension ScheduleCommand {
    convenience init?(json: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: json),
              let decoded = try? JSONDecoder().decode(ScheduleCommand.self, from: data) else { return nil }
        self.init(address: decoded.address, method: decoded.method, body: decoded.body)
    }
}
