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
    
    public var resourceType: BridgeResourceType {
        return .rule
    };
    
    public let identifier: String
    public let name: String
    public let lasttriggered: Date?
    public let created: Date
    public let timestriggered: Int
    public let owner: String
    public let status: String
    public let conditions: [RuleCondition]
    public let actions: [RuleAction]
    
    public required init?(json: JSON) {
        
        let dateFormatter = DateFormatter.hueApiDateFormatter
        
        guard let identifier: String = "id" <~~ json else {
            Log.error("Can't create Rule, missing required attribute \"id\" in JSON:\n \(json)"); return nil
        }
        
        guard let name: String = "name" <~~ json else {
            Log.error("Can't create Rule, missing required attribute \"name\" in JSON:\n \(json)"); return nil
        }
        
        guard let created: Date = Decoder.decode(dateForKey: "created", dateFormatter:dateFormatter)(json) else {
            Log.error("Can't create Rule, missing required attribute \"created\" in JSON:\n \(json)"); return nil
        }
        
        guard let timestriggered: Int = "timestriggered" <~~ json else {
            Log.error("Can't create Rule, missing required attribute \"timestriggered\" in JSON:\n \(json)"); return nil
        }
        
        guard let owner: String = "owner" <~~ json else {
            Log.error("Can't create Rule, missing required attribute \"owner\" in JSON:\n \(json)"); return nil
        }
        
        guard let status: String = "status" <~~ json else {
            Log.error("Can't create Rule, missing required attribute \"status\" in JSON:\n \(json)"); return nil
        }
        
        guard let conditionJSONs: [JSON] = "conditions" <~~ json else {
            Log.error("Can't create Rule, missing required attribute \"conditions\" in JSON:\n \(json)"); return nil
        }
        
        guard let actionJSONs: [JSON] = "actions" <~~ json else {
            Log.error("Can't create Rule, missing required attribute \"actions\" in JSON:\n \(json)"); return nil
        }
        
        
        self.identifier = identifier
        self.name = name
        self.created = created as Date
        self.lasttriggered = Decoder.decode(dateForKey: "lasttriggered", dateFormatter:dateFormatter)(json)
        self.timestriggered = timestriggered
        self.owner = owner
        self.status = status
        self.conditions = [RuleCondition].from(jsonArray: conditionJSONs)!
        self.actions = [RuleAction].from(jsonArray: actionJSONs)!
    }
    
    public func toJSON() -> JSON? {
        
        let dateFormatter = DateFormatter.hueApiDateFormatter
        
        let json = jsonify([
            "id" ~~> self.identifier,
            "name" ~~> self.name,
            Encoder.encode(dateForKey: "created", dateFormatter: dateFormatter)(self.created),
            Encoder.encode(dateForKey: "lasttriggered", dateFormatter: dateFormatter)(self.lasttriggered),
            "timestriggered" ~~> self.timestriggered,
            "owner" ~~> self.owner,
            "status" ~~> self.status,
            "conditions" ~~> self.conditions,
            "actions" ~~> self.actions
            ])
        
        return json
    }
}

extension Rule: Hashable {
    
    public var hashValue: Int {
        
        return Int(self.identifier)!
    }
}

public func ==(lhs: Rule, rhs: Rule) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.name  == rhs.name &&
        lhs.created  == rhs.created &&
        lhs.lasttriggered == rhs.lasttriggered &&
        lhs.timestriggered  == rhs.timestriggered &&
        lhs.owner  == rhs.owner &&
        lhs.status  == rhs.status &&
        lhs.conditions  == rhs.conditions &&
        lhs.actions  == rhs.actions
}
