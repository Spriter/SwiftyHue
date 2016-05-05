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

    public let status: Bool
    
    required public init?(json: JSON) {
        
        guard let status: Bool = "status" <~~ json
            
            else { return nil }
        
        self.status = status
        
        super.init(json: json)
    }
}
