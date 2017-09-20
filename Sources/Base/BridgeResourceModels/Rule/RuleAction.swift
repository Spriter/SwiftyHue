//
//  RuleAction.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class RuleAction: Gloss.Decodable, Gloss.Encodable {
    
    public let address: String
    public let method: String
    public let body: [String: Any]
    
    public required init?(json: JSON) {
        
        guard let address: String = "address" <~~ json else {
            Log.error("Can't create RuleAction, missing required attribute \"address\" in JSON:\n \(json)"); return nil
        }
        
        guard let method: String = "method" <~~ json else {
            Log.error("Can't create RuleAction, missing required attribute \"method\" in JSON:\n \(json)"); return nil
        }
        
        guard let body: JSON = "body" <~~ json else {
            Log.error("Can't create RuleAction, missing required attribute \"body\" in JSON:\n \(json)"); return nil
        }
        
        self.address = address
        self.method = method
        self.body = body
    }
    
    public func toJSON() -> JSON? {
        
        let json = jsonify([
            "address" ~~> address,
            "method" ~~> method,
            "body" ~~> body
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
            lhs.method  == rhs.method// &&
//            lhs.body  == rhs.body
}
