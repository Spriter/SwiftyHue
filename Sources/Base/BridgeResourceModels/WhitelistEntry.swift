//
//  WhitelistEntry.swift
//  Pods
//
//  Created by Marcel Dittmann on 22.04.16.
//
//

import Foundation

public struct WhitelistEntry: BridgeResource, BridgeResourceDictGenerator {
    
    public typealias AssociatedBridgeResourceType = WhitelistEntry
    
    public var resourceType: BridgeResourceType {
        return .whitelistEntry
    }
    
    public let identifier: String
    
    /**
     The date when the entry is used for the last time
     */
    public let lastUseDate: Date?
    
    /**
     Creation date of the entry
     */
    public let createDate: Date?
    
    /**
     Name of the entry
     */
    public let name: String
    
    public var username: String? {
        return identifier
    }
    
    public init?(json: JSON) {
        let dateFormatter = DateFormatter.hueApiDateFormatter

        guard let identifier = json["id"] as? String,
              let name = json["name"] as? String else { return nil }

        self.identifier = identifier
        self.name = name

        if let lastUse = json["last use date"] as? String {
            self.lastUseDate = dateFormatter.date(from: lastUse)
        } else {
            self.lastUseDate = nil
        }

        if let created = json["create date"] as? String {
            self.createDate = dateFormatter.date(from: created)
        } else {
            self.createDate = nil
        }
    }
    
    public func toJSON() -> JSON? {
        let dateFormatter = DateFormatter.hueApiDateFormatter
        var json: JSON = [
            "id": identifier,
            "name": name
        ]
        if let lastUseDate {
            json["last use date"] = dateFormatter.string(from: lastUseDate)
        }
        if let createDate {
            json["create date"] = dateFormatter.string(from: createDate)
        }
        return json
    }
}

extension WhitelistEntry: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(Int(self.identifier) ?? 0)
    }
}

public func ==(lhs: WhitelistEntry, rhs: WhitelistEntry) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.name == rhs.name &&
        lhs.lastUseDate == rhs.lastUseDate &&
        lhs.createDate == rhs.createDate
}
