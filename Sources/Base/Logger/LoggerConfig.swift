//
//  LoggerConfig.swift
//  Pods
//
//  Created by Marcel Dittmann on 15.05.16.
//
//

import Foundation
import Log

let Log = Logger(formatter: .Detailed, theme: .TomorrowNight)

extension Formatters {
    static let Detailed = Formatter("[%@] %@.%@:%@ %@: %@", [
        .date("yyyy-MM-dd HH:mm:ss.SSS"),
        .file(fullPath: false, fileExtension: false),
        .function,
        .line,
        .level,
        .message
        ])
}

extension Themes {
    static let TomorrowNight = Theme(
        trace:   "#C5C8C6",
        debug:   "#81A2BE",
        info:    "#B5BD68",
        warning: "#F0C674",
        error:   "#CC6666"
    )
}
