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
    
    public let version: Int?
    public let data: String?
    
    public init?(json: JSON) {
        
        version = "version" <~~ json
        data = "data" <~~ json
        
    }
    
    public func toJSON() -> JSON? {
        
        return jsonify([
            "version" ~~> self.version,
            "data" ~~> self.data,
        ])
    }
}