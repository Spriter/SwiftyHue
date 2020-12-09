//
//  NSDateFormatter+Extension.swift
//  Pods
//
//  Created by Marcel Dittmann on 22.04.16.
//
//

import Foundation

public extension DateFormatter {
    
    static public var hueApiDateFormatter: DateFormatter {
    
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
   
        return dateFormatter
    }
}
