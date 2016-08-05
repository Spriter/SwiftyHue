//
//  BridgeFinderConsumer.swift
//  SwiftyHue
//
//  Created by Nils Lattek on 28.05.16.
//
//

import XCTest
@testable import SwiftyHue

class BridgeFinderConsumer: BridgeFinderDelegate {
    var resultBridges: [HueBridge]?
    var asyncExpectation: XCTestExpectation?

    func bridgeFinder(_ finder: BridgeFinder, didFinishWithResult bridges: [HueBridge]) {
        guard let expectation = asyncExpectation else {
            XCTFail("Set expectation in test")
            return
        }

        resultBridges = bridges
        expectation.fulfill()
    }
}
