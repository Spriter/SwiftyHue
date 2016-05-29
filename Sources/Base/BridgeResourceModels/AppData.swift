//
//  AppData.swift
//  Pods
//
//  Created by Marcel Dittmann on 21.04.16.
//
//

import Foundation
import Gloss

public struct AppData: Decodable, Encodable {
    
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
    
    public init?(json: JSON) {
        
        guard let version: Int = "data" <~~ json,
        let data: String = "version" <~~ json
        else {return nil}
        
        self.version = version
        self.data = data
        
    }
    
    public func toJSON() -> JSON? {
        
        return jsonify([
            "version" ~~> version,
            "data" ~~> data,
        ])
    }
}

extension AppData: Hashable {
    
    public var hashValue: Int {
        
        return version
    }
}
public func ==(lhs: AppData, rhs: AppData) -> Bool {
    return lhs.version == rhs.version && lhs.data == rhs.data
}