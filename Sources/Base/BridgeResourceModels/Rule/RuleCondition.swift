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
    case EQ = "eq", GT = "gt", LT = "lt", DX = "dx", DDX = "ddx"
    
}

public class RuleCondition: Glossy  {
    
    public let address: String
    public let conditionOperator: RuleConditionOperator?
    public let value: String?
    
    public required init?(json: JSON) {
        
        guard let address: String = "address" <~~ json else {
            print("Can't create RuleCondition, missing required attribute \"address\" in JSON:\n \(json)"); return nil
        }
        
//        guard let conditionOperator: RuleConditionOperator = "operator" <~~ json else {
//            Log.error("Can't create RuleCondition, missing required attribute \"operator\" in JSON:\n \(json)"); return nil
//        }
        
        self.address = address
        
        self.conditionOperator = "operator" <~~ json
        self.value = "value" <~~ json
    }
    
    public func toJSON() -> JSON? {
        
        let json = jsonify([
            "address" ~~> address,
            "operator" ~~> conditionOperator,
            "value" ~~> value
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
