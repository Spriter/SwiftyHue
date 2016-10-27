//
//  BridgeFinderDelegate.swift
//  HueSDK
//
//  Created by Nils Lattek on 24.04.16.
//  Copyright © 2016 Nils Lattek. All rights reserved.
//

import Foundation

/// Protocol for handling BridgeFinder results
public protocol BridgeFinderDelegate: class {
    /**
     Search for HueBridges finished.
     
     - Parameters:
        - finder: The BridgeFinder
        - bridges: An array containing all found bridges. If none was found the array will be empty.
    */
    func bridgeFinder(_ finder: BridgeFinder, didFinishWithResult bridges: [HueBridge])
}
