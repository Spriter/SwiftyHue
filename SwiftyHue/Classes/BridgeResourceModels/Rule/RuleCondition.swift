//
//  RuleCondition.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public enum RuleConditionOperator: String {
    case EQ = "eq", GT = "gt", LT = "lt", DX = "dx"
}

public class RuleCondition: Decodable, Encodable  {
    
    public let address: String
    public let conditionOperator: RuleConditionOperator
    public let value: String
    
    public required init?(json: JSON) {
        
        guard let address: String = "address" <~~ json,
            let conditionOperator: RuleConditionOperator = "operator" <~~ json,
            let value: String = "value" <~~ json
            
            else { return nil }
        
        self.address = address
        self.conditionOperator = conditionOperator
        self.value = value
    }
    
    public func toJSON() -> JSON? {
        
        let json = jsonify([
            "address" ~~> self.address,
            "conditionOperator" ~~> self.conditionOperator,
            "value" ~~> self.value
            ])
        
        return json
    }
}

extension RuleCondition: Hashable {
    
    public var hashValue: Int {
        
        return 1
    }
}

public func ==(lhs: RuleCondition, rhs: RuleCondition) -> Bool {
    return lhs.address == rhs.address &&
        lhs.conditionOperator  == rhs.conditionOperator &&
        lhs.value  == rhs.value
}