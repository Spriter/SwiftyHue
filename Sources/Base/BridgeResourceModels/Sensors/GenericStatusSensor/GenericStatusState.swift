//
//  GenericStatusState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class GenericStatusState: SensorState {

    public let status: Int
    
    required public init?(json: JSON) {
        
        guard let status: Int = "status" <~~ json else {
            Log.error("Can't create GenericStatusState, missing required attribute \"status\" in JSON:\n \(json)"); return nil
        }
        
        self.status = status
        
        super.init(json: json)
    }
    
    public override func toJSON() -> JSON? {
        
        if var superJson = super.toJSON() {
            let json = jsonify([
                "status" ~~> status
                ])
            superJson.unionInPlace(json!)
            return superJson
        }
        
        return nil
    }
}

public func ==(lhs: GenericStatusState, rhs: GenericStatusState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated &&
        lhs.status == rhs.status
}