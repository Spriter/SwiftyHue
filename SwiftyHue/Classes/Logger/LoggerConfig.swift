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
        .Date("yyyy-MM-dd HH:mm:ss.SSS"),
        .File(fullPath: false, fileExtension: false),
        .Function,
        .Line,
        .Level,
        .Message
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