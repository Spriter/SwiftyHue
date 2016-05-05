//
//  RuleAction.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class RuleAction: Decodable  {
    
    public let address: String
    public let method: String
    public let body: JSON
    
    public required init?(json: JSON) {
        
        guard let address: String = "address" <~~ json,
            let method: String = "operator" <~~ json,
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