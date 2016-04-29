//
//  NSDateFormatter+Extension.swift
//  Pods
//
//  Created by Marcel Dittmann on 22.04.16.
//
//

import Foundation

public extension NSDateFormatter {
    
    static public var hueApiDateFormatter: NSDateFormatter {
    
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
   
        return dateFormatter
    }
}