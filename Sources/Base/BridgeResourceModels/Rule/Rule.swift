//
//  Rule.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation

public class Rule: BridgeResource, BridgeResourceDictGenerator {

    public typealias AssociatedBridgeResourceType = Rule

    public var resourceType: BridgeResourceType {
        return .rule
    }

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

        guard let identifier = json["id"] as? String else {
            print("Can't create Rule, missing required attribute \"id\" in JSON:\n \(json)"); return nil
        }

        guard let name = json["name"] as? String else {
            print("Can't create Rule, missing required attribute \"name\" in JSON:\n \(json)"); return nil
        }

        guard let createdString = json["created"] as? String,
              let created = dateFormatter.date(from: createdString) else {
            print("Can't create Rule, missing required attribute \"created\" in JSON:\n \(json)"); return nil
        }

        guard let timestriggered = json["timestriggered"] as? Int else {
            print("Can't create Rule, missing required attribute \"timestriggered\" in JSON:\n \(json)"); return nil
        }

        guard let owner = json["owner"] as? String else {
            print("Can't create Rule, missing required attribute \"owner\" in JSON:\n \(json)"); return nil
        }

        guard let status = json["status"] as? String else {
            print("Can't create Rule, missing required attribute \"status\" in JSON:\n \(json)"); return nil
        }

        guard let conditionJSONs = json["conditions"] as? [JSON] else {
            print("Can't create Rule, missing required attribute \"conditions\" in JSON:\n \(json)"); return nil
        }

        guard let actionJSONs = json["actions"] as? [JSON] else {
            print("Can't create Rule, missing required attribute \"actions\" in JSON:\n \(json)"); return nil
        }

        let conditions = conditionJSONs.compactMap { RuleCondition(json: $0) }
        let actions = actionJSONs.compactMap { RuleAction(json: $0) }
        guard conditions.count == conditionJSONs.count, actions.count == actionJSONs.count else {
            return nil
        }

        self.identifier = identifier
        self.name = name
        self.created = created
        if let lastTriggeredString = json["lasttriggered"] as? String {
            self.lasttriggered = dateFormatter.date(from: lastTriggeredString)
        } else {
            self.lasttriggered = nil
        }
        self.timestriggered = timestriggered
        self.owner = owner
        self.status = status
        self.conditions = conditions
        self.actions = actions
    }

    public func toJSON() -> JSON? {

        let dateFormatter = DateFormatter.hueApiDateFormatter

        return [
            "id": self.identifier,
            "name": self.name,
            "created": dateFormatter.string(from: self.created),
            "lasttriggered": self.lasttriggered.map { dateFormatter.string(from: $0) } as Any,
            "timestriggered": self.timestriggered,
            "owner": self.owner,
            "status": self.status,
            "conditions": self.conditions.compactMap { $0.toJSON() },
            "actions": self.actions.compactMap { $0.toJSON() }
        ].compactMapValues { $0 }
    }
}

extension Rule: Hashable {

    public func hash(into hasher: inout Hasher) {

        hasher.combine(Int(self.identifier)!)
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
