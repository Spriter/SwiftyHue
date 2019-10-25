//
//  NSDateFormatter+Extension.swift
//  Pods
//
//  Created by Marcel Dittmann on 22.04.16.
//
//

import Foundation

public extension DateFormatter {
    
    static var hueApiDateFormatter: DateFormatter {
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
   
        return dateFormatter
    }
}
