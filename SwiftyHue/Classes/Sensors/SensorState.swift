//
//  SensorState.swift
//  Pods
//
//  Created by Jerome Schmitz on 01.05.16.
//
//

import Foundation
import Gloss

public class SensorState: Decodable {
    
    public let lastUpdated: NSDate?
    
    required public init?(json: JSON) {
        
        let dateFormatter = NSDateFormatter.hueApiDateFormatter
        
        self.lastUpdated = Decoder.decodeDate("lastupdated", dateFormatter:dateFormatter)(json)
    }
}