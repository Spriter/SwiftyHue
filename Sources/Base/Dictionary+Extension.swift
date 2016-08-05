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
        _ dictionary: Dictionary<Key, Value>) {
        for (key, value) in dictionary {
            self[key] = value
        }
    }
    
    // Thanks Airspeed Velocity
    mutating func unionInPlace<S: Sequence where
        S.Iterator.Element == (Key,Value)>(_ sequence: S) {
        for (key, value) in sequence {
            self[key] = value
        }
    }
}
