//
//  AppData.swift
//  Pods
//
//  Created by Marcel Dittmann on 21.04.16.
//
//

import Foundation

public struct AppData: Codable {

    /**
        App specific version of the data field. App should take versioning into account when parsing the data string.
     */
    public let version: Int

    /**
        App specific data. Free format string.
     */
    public let data: String

    public init(version: Int, data: String) {
        self.version = version
        self.data = data
    }
}

extension AppData: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(version)
    }
}
public func ==(lhs: AppData, rhs: AppData) -> Bool {
    return lhs.version == rhs.version && lhs.data == rhs.data
}


public extension AppData {
    func toJSON() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let object = try? JSONSerialization.jsonObject(with: data),
              let json = object as? [String: Any] else { return nil }
        return json
    }
}


public extension AppData {
    init?(json: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: json),
              let decoded = try? JSONDecoder().decode(AppData.self, from: data) else { return nil }
        self = decoded
    }
}
