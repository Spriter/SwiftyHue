//
//  Scene.swift
//  Pods
//
//  Created by Marcel Dittmann on 21.04.16.
//
//

import Foundation

public class PartialScene: BridgeResource, BridgeResourceDictGenerator {

    public typealias AssociatedBridgeResourceType = PartialScene

    public var resourceType: BridgeResourceType { .scene }

    public let identifier: String
    public let name: String
    public let lightIdentifiers: [String]?
    public let owner: String
    public let recycle: Bool
    public let locked: Bool
    public let appData: AppData?
    public let lastUpdated: Date?
    public let version: Int

    public required init?(json: [String: Any]) {
        guard let identifier = json["id"] as? String,
              let name = json["name"] as? String,
              let lightIdentifiers = json["lights"] as? [String],
              let owner = json["owner"] as? String,
              let recycle = json["recycle"] as? Bool,
              let locked = json["locked"] as? Bool,
              let version = json["version"] as? Int else {
            print("Can't create Partial Scene from JSON:\n \(json)")
            return nil
        }

        self.identifier = identifier
        self.name = name
        self.lightIdentifiers = lightIdentifiers
        self.owner = owner
        self.recycle = recycle
        self.locked = locked
        self.version = version

        if let appDataJSON = json["appdata"] as? [String: Any] {
            self.appData = AppData(json: appDataJSON)
        } else {
            self.appData = nil
        }

        let dateFormatter = DateFormatter.hueApiDateFormatter
        if let lastUpdatedString = json["lastupdated"] as? String {
            lastUpdated = dateFormatter.date(from: lastUpdatedString)
        } else {
            lastUpdated = nil
        }
    }

    public func toJSON() -> [String: Any]? {
        let dateFormatter = DateFormatter.hueApiDateFormatter
        var json: [String: Any] = [
            "id": identifier,
            "name": name,
            "owner": owner,
            "recycle": recycle,
            "locked": locked,
            "version": version
        ]
        if let lightIdentifiers { json["lights"] = lightIdentifiers }
        if let appDataJSON = appData?.toJSON() { json["appdata"] = appDataJSON }
        if let lastUpdated { json["lastupdated"] = dateFormatter.string(from: lastUpdated) }
        return json
    }
}

extension PartialScene: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(Int(self.identifier)!)
    }
}

public func ==(lhs: PartialScene, rhs: PartialScene) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.name == rhs.name &&
        (lhs.lightIdentifiers ?? []) == (rhs.lightIdentifiers ?? []) &&
        lhs.owner == rhs.owner &&
        lhs.recycle == rhs.recycle &&
        lhs.locked == rhs.locked &&
        lhs.appData == rhs.appData &&
        lhs.lastUpdated == rhs.lastUpdated &&
        lhs.version == rhs.version
}
