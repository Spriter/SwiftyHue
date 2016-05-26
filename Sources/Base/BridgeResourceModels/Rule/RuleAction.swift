//
//  RuleAction.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class RuleAction: Decodable, Encodable {
    
    public let address: String
    public let method: String
    public let body: NSDictionary
    
    public required init?(json: JSON) {
        
        guard let address: String = "address" <~~ json,
            let method: String = "method" <~~ json,
            let body: JSON = "body" <~~ json
            
            else { return nil }
        
        self.address = address
        self.method = method
        self.body = body
    }
    
    public func toJSON() -> JSON? {
        
        let json = jsonify([
            "address" ~~> self.address,
            "method" ~~> self.method,
            "body" ~~> self.body
            ])
        
        return json
    }
}

extension RuleAction: Hashable {
    
    public var hashValue: Int {
        
        return 1
    }
}

public func ==(lhs: RuleAction, rhs: RuleAction) -> Bool {
    return lhs.address == rhs.address &&
            lhs.method  == rhs.method &&
            lhs.body  == rhs.body
}