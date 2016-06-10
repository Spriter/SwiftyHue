//
//  SensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class SensorState: Decodable, Encodable {
    
    public let lastUpdated: NSDate?
    
    required public init?(json: JSON) {
        
        let dateFormatter = NSDateFormatter.hueApiDateFormatter
        
        self.lastUpdated = Decoder.decodeDate("lastupdated", dateFormatter:dateFormatter)(json)
    }
    
    public func toJSON() -> JSON? {
        
        let dateFormatter = NSDateFormatter.hueApiDateFormatter
        
        let json = jsonify([
            Encoder.encodeDate("lastupdated", dateFormatter: dateFormatter)(self.lastUpdated)
            ])
        
        return json
    }
}

extension SensorState: Hashable {
    
    public var hashValue: Int {
        
        return 1
    }
}

public func ==(lhs: SensorState, rhs: SensorState) -> Bool {
    return lhs.lastUpdated == rhs.lastUpdated
}