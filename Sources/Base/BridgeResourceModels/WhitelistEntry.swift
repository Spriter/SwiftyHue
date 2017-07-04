//
//  WhitelistEntry.swift
//  Pods
//
//  Created by Marcel Dittmann on 22.04.16.
//
//

import Foundation
import Gloss

public struct WhitelistEntry: BridgeResource, BridgeResourceDictGenerator {
    
    public typealias AssociatedBridgeResourceType = WhitelistEntry
    
    public var resourceType: BridgeResourceType {
        return .whitelistEntry
    };
    
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
        return identifier;
    }
    
    public init?(json: JSON) {
        
        let dateFormatter = DateFormatter.hueApiDateFormatter
        
        guard let identifier: String = "id" <~~ json,
            let name: String = "name" <~~ json,
            let lastUseDate: Date = Decoder.decode(dateForKey: "last use date", dateFormatter:dateFormatter)(json),
            let createDate: Date = Decoder.decode(dateForKey: "create date", dateFormatter: dateFormatter)(json)
            else { return nil }
        
        self.identifier = identifier
        self.name = name
        self.lastUseDate = lastUseDate as Date
        self.createDate = createDate as Date
        
    }
    
    public func toJSON() -> JSON? {
        
        let dateFormatter = DateFormatter.hueApiDateFormatter
        
        let json = jsonify([
            "id" ~~> identifier,
            "name" ~~> name,
            Encoder.encode(dateForKey: "last use date", dateFormatter: dateFormatter)(lastUseDate),
            Encoder.encode(dateForKey: "create date", dateFormatter: dateFormatter)(createDate)
            ])
        
        return json
    }
}

extension WhitelistEntry: Hashable {
    
    public var hashValue: Int {
        
        return Int(identifier)!
    }
}

public func ==(lhs: WhitelistEntry, rhs: WhitelistEntry) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.name == rhs.identifier &&
        lhs.lastUseDate == rhs.lastUseDate &&
        lhs.createDate == rhs.createDate
}
