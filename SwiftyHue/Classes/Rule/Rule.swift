//
//  Rule.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class Rule: BridgeResource, BridgeResourceDictGenerator {
    
    public typealias AssociatedBridgeResourceType = Rule
    
    public let identifier: String
    public let name: String
    public let lasttriggered: NSDate?
    public let creationtime: NSDate
    public let timestriggered: Int
    public let owner: String
    public let status: String
    public let conditions: [RuleCondition]
    public let actions: [RuleAction]
    
    public required init?(json: JSON) {
        
        let dateFormatter = NSDateFormatter.hueApiDateFormatter
        
        guard let identifier: String = "id" <~~ json,
            let name: String = "name" <~~ json,
            let creationtime: NSDate = Decoder.decodeDate("creationtime", dateFormatter:dateFormatter)(json),
            let timestriggered: Int = "timestriggered" <~~ json,
            let owner: String = "owner" <~~ json,
            let status: String = "status" <~~ json,
            let conditionJSONs: [JSON] = "conditions" <~~ json,
            let actionJSONs: [JSON] = "actions" <~~ json
            
            else { return nil }
        
        self.identifier = identifier
        self.name = name
        self.creationtime = creationtime
        self.lasttriggered = Decoder.decodeDate("lasttriggered", dateFormatter:dateFormatter)(json)
        self.timestriggered = timestriggered
        self.owner = owner
        self.status = status
        self.conditions = [RuleCondition].fromJSONArray(conditionJSONs)
        self.actions = [RuleAction].fromJSONArray(actionJSONs)
    }
    
    public func toJSON() -> JSON? {
        
        let dateFormatter = NSDateFormatter.hueApiDateFormatter
        
        var json = jsonify([
            "id" ~~> self.identifier,
            "name" ~~> self.name,
            "creationtime" ~~> Encoder.encodeDate("creationtime", dateFormatter: dateFormatter)(self.creationtime),
            "lasttriggered" ~~> Encoder.encodeDate("lasttriggered", dateFormatter: dateFormatter)(self.lasttriggered),
            "timestriggered" ~~> self.timestriggered,
            "owner" ~~> self.owner,
            "status" ~~> self.status,
            "conditions" ~~> self.conditions,
            "actions" ~~> self.actions
            ])
        
        return json
    }
}