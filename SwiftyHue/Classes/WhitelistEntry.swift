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
    
    public let identifier: String
    
    /**
     The date when the entry is used for the last time
     */
    public let lastUseDate: NSDate?
    
    /**
     Creation date of the entry
     */
    public let createDate: NSDate?
    
    /**
     Name of the entry
     */
    public let name: String
    
    public var username: String? {
        return identifier;
    }
    
    public init?(json: JSON) {
        
        let dateFormatter = NSDateFormatter.hueApiDateFormatter
        
        guard let identifier: String = "id" <~~ json,
            let name: String = "name" <~~ json,
            let lastUseDate: NSDate = Decoder.decodeDate("last use date", dateFormatter:dateFormatter)(json),
            let createDate: NSDate = Decoder.decodeDate("create date", dateFormatter: dateFormatter)(json)
            else { return nil }
        
        self.identifier = identifier
        self.name = name
        self.lastUseDate = lastUseDate
        self.createDate = createDate
        
    }
    
    public func toJSON() -> JSON? {
        
        let dateFormatter = NSDateFormatter.hueApiDateFormatter
        
        var json = jsonify([
            "id" ~~> self.identifier,
            "name" ~~> self.name,
            Encoder.encodeDate("last use date", dateFormatter: dateFormatter)(self.lastUseDate),
            Encoder.encodeDate("create date", dateFormatter: dateFormatter)(self.createDate)
            ])
        
        return json
    }
}