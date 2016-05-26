//
//  Dictionary+Extension.swift
//  Pods
//
//  Created by Jerome Schmitz on 16.05.16.
//
//

import Foundation

extension Dictionary {
    mutating func unionInPlace(
        dictionary: Dictionary<Key, Value>) {
        for (key, value) in dictionary {
            self[key] = value
        }
    }
    
    // Thanks Airspeed Velocity
    mutating func unionInPlace<S: SequenceType where
        S.Generator.Element == (Key,Value)>(sequence: S) {
        for (key, value) in sequence {
            self[key] = value
        }
    }
}