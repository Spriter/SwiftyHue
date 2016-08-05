//
//  BridgeAuthenticatorConsumer.swift
//  SwiftyHue
//
//  Created by Nils Lattek on 28.05.16.
//
//

import XCTest
import SwiftyHue

class BridgeAuthenticatorConsumer: BridgeAuthenticatorDelegate {
    var asyncExpectation: XCTestExpectation?
    var timeoutCalled = false
    var failedWithError: NSError?
    var finishWithUsername: String?
    var ignoreLinkButtonCall = false
    var requiresLinkButtonCallCount = 0

    func bridgeAuthenticatorDidTimeout(_ authenticator: BridgeAuthenticator) {
        guard let expectation = asyncExpectation else {
            XCTFail("Set expectation in test")
            return
        }

        timeoutCalled = true
        expectation.fulfill()
    }

    func bridgeAuthenticatorRequiresLinkButtonPress(_ authenticator: BridgeAuthenticator) {
        requiresLinkButtonCallCount += 1
        if ignoreLinkButtonCall {
            return
        }

        guard let expectation = asyncExpectation else {
            XCTFail("Set expectation in test")
            return
        }

        expectation.fulfill()
    }

    func bridgeAuthenticator(_ authenticator: BridgeAuthenticator, didFailWithError error: NSError) {
        guard let expectation = asyncExpectation else {
            XCTFail("Set expectation in test")
            return
        }

        failedWithError = error
        expectation.fulfill()
    }

    func bridgeAuthenticator(_ authenticator: BridgeAuthenticator, didFinishAuthentication username: String) {
        guard let expectation = asyncExpectation else {
            XCTFail("Set expectation in test")
            return
        }

        finishWithUsername = username
        expectation.fulfill()
    }
}
