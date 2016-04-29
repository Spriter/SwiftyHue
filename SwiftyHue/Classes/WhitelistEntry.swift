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
    
    public typealias BridgeResourceType = WhitelistEntry
    
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
        
        guard let identifier: String = "id" <~~ json,
            let name: String = "name" <~~ json
            else { return nil }
        
        self.identifier = identifier
        self.name = name
        
        let dateFormatter = NSDateFormatter.hueApiDateFormatter
        
        lastUseDate = Decoder.decodeDate("last use date", dateFormatter:dateFormatter)(json)
        createDate = Decoder.decodeDate("create date", dateFormatter: dateFormatter)(json)
        
    }
    
    public func toJSON() -> JSON? {
        return [:]
    }
}