//
//  BridgeFinderConsumer.swift
//  HueSDK
//
//  Created by Nils Lattek on 25.04.16.
//  Copyright © 2016 Nils Lattek. All rights reserved.
//

import XCTest
import SwiftyHue

class BridgeFinderConsumer: BridgeFinderDelegate {
    var resultBridges: [HueBridge]?
    var asyncExpectation: XCTestExpectation?

    func bridgeFinder(finder: BridgeFinder, didFinishWithResult bridges: [HueBridge]) {
        guard let expectation = asyncExpectation else {
            XCTFail("Set expectation in test")
            return
        }

        resultBridges = bridges
        expectation.fulfill()
    }
}