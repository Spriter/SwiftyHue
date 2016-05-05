//
//  RuleCondition.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public enum RuleConditionOperator {
    case EQ, GT, LT, DX
}

public class RuleCondition: Decodable  {
    
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