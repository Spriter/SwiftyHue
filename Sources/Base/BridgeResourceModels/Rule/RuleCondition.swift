//
//  RuleCondition.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation

public enum RuleConditionOperator: String, Codable {
    case EQ = "eq", GT = "gt", LT = "lt", DX = "dx", DDX = "ddx"
}

public class RuleCondition: Codable  {

    public let address: String
    public let conditionOperator: RuleConditionOperator?
    public let value: String?

    enum CodingKeys: String, CodingKey {
        case address
        case conditionOperator = "operator"
        case value
    }

    public init(address: String, conditionOperator: RuleConditionOperator?, value: String?) {
        self.address = address
        self.conditionOperator = conditionOperator
        self.value = value
    }
}

extension RuleCondition: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(address)
        hasher.combine(conditionOperator?.rawValue)
        hasher.combine(value)
    }
}

public func ==(lhs: RuleCondition, rhs: RuleCondition) -> Bool {
    return lhs.address == rhs.address &&
        lhs.conditionOperator  == rhs.conditionOperator &&
        lhs.value  == rhs.value
}


public extension RuleCondition {
    convenience init?(json: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: json),
              let decoded = try? JSONDecoder().decode(RuleCondition.self, from: data) else { return nil }
        self.init(address: decoded.address, conditionOperator: decoded.conditionOperator, value: decoded.value)
    }

    func toJSON() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let object = try? JSONSerialization.jsonObject(with: data),
              let json = object as? [String: Any] else { return nil }
        return json
    }
}
