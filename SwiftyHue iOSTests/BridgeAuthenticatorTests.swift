//
//  BridgeAuthenticatorTests.swift
//  SwiftyHue
//
//  Created by Nils Lattek on 28.05.16.
//
//

import XCTest
@testable import SwiftyHue
import Nocilla

class BridgeAuthenticatorTests: XCTestCase {

    override func setUp() {
        super.setUp()
        LSNocilla.sharedInstance().start()
    }

    override func tearDown() {
        LSNocilla.sharedInstance().stop()
        super.tearDown()
    }

    func testErrorDelegate() {
        let consumer = BridgeAuthenticatorConsumer()
        let bridge = HueBridge(ip: "192.168.1.130", deviceType: "urn:schemas-upnp-org:device:Basic:1", friendlyName: "Philips hue", modelDescription: "Philips hue", modelName: "bridge", serialNumber: "001788102201", UDN: "uuid:2f402f80-da50-11e1-9b23-001788102201", icons: [])
        let authenticator = BridgeAuthenticator(bridge: bridge, uniqueIdentifier: "tests#simulator", pollingInterval: 1, timeout: 2)
        authenticator.delegate = consumer

        // empty body
        stubRequest("POST", "http://192.168.1.130/api").andReturn(200)!
        consumer.asyncExpectation = expectation(description: "authenticate")
        authenticator.start()
        waitForExpectations(timeout: 1) { (error) in
            if let error = error {
                XCTFail("\(error)")
            }

            XCTAssertNotNil(consumer.failedWithError)
        }

        LSNocilla.sharedInstance().clearStubs()
        // wrong status code
        stubRequest("POST", "http://192.168.1.130/api").andReturn(400)!
        consumer.asyncExpectation = expectation(description: "authenticate")
        authenticator.start()
        waitForExpectations(timeout: 1) { (error) in
            if let error = error {
                XCTFail("\(error)")
            }

            XCTAssertNotNil(consumer.failedWithError)
        }

        LSNocilla.sharedInstance().clearStubs()
        // invalid data
        stubRequest("POST", "http://192.168.1.130/api").andReturn(200)!.withBody("invalid")!
        consumer.asyncExpectation = expectation(description: "authenticate")
        authenticator.start()
        waitForExpectations(timeout: 1) { (error) in
            if let error = error {
                XCTFail("\(error)")
            }

            XCTAssertNotNil(consumer.failedWithError)
        }
    }

    func testLinkButtonDelegate() {
        let consumer = BridgeAuthenticatorConsumer()
        let bridge = HueBridge(ip: "192.168.1.130", deviceType: "urn:schemas-upnp-org:device:Basic:1", friendlyName: "Philips hue", modelDescription: "Philips hue", modelName: "bridge", serialNumber: "001788102201", UDN: "uuid:2f402f80-da50-11e1-9b23-001788102201", icons: [])
        let authenticator = BridgeAuthenticator(bridge: bridge, uniqueIdentifier: "tests#simulator", pollingInterval: 1, timeout: 2)
        authenticator.delegate = consumer

        // empty body
        stubRequest("POST", "http://192.168.1.130/api").andReturn(200)!
            .withBody("[{\"error\": {\"type\": 101, \"address\": \"\", \"description\": \"link button not pressed\"}}]")
        consumer.asyncExpectation = expectation(description: "authenticate")
        authenticator.start()
        waitForExpectations(timeout: 1) { (error) in
            if let error = error {
                XCTFail("\(error)")
            }

            XCTAssertEqual(consumer.requiresLinkButtonCallCount, 1)
        }
    }

    func testTimeoutDelegate() {
        let consumer = BridgeAuthenticatorConsumer()
        consumer.ignoreLinkButtonCall = true
        let bridge = HueBridge(ip: "192.168.1.130", deviceType: "urn:schemas-upnp-org:device:Basic:1", friendlyName: "Philips hue", modelDescription: "Philips hue", modelName: "bridge", serialNumber: "001788102201", UDN: "uuid:2f402f80-da50-11e1-9b23-001788102201", icons: [])
        let authenticator = BridgeAuthenticator(bridge: bridge, uniqueIdentifier: "tests#simulator", pollingInterval: 1, timeout: 1)
        authenticator.delegate = consumer

        // empty body
        stubRequest("POST", "http://192.168.1.130/api").andReturn(200)!
            .withBody("[{\"error\": {\"type\": 101, \"address\": \"\", \"description\": \"link button not pressed\"}}]")
        consumer.asyncExpectation = expectation(description: "authenticate")
        authenticator.start()
        waitForExpectations(timeout: 3) { (error) in
            if let error = error {
                XCTFail("\(error)")
            }

            XCTAssertEqual(consumer.requiresLinkButtonCallCount, 1)
            XCTAssertTrue(consumer.timeoutCalled)
        }
    }

    func testFinishAuthenticationDelegate() {
        let consumer = BridgeAuthenticatorConsumer()
        consumer.ignoreLinkButtonCall = true
        let bridge = HueBridge(ip: "192.168.1.130", deviceType: "urn:schemas-upnp-org:device:Basic:1", friendlyName: "Philips hue", modelDescription: "Philips hue", modelName: "bridge", serialNumber: "001788102201", UDN: "uuid:2f402f80-da50-11e1-9b23-001788102201", icons: [])
        let authenticator = BridgeAuthenticator(bridge: bridge, uniqueIdentifier: "tests#simulator", pollingInterval: 1, timeout: 1)
        authenticator.delegate = consumer

        // empty body
        stubRequest("POST", "http://192.168.1.130/api")
            .withBody("{\"devicetype\":\"tests#simulator\"}")!
            .andReturn(200)!
            .withBody("[{\"success\": {\"username\": \"1028d66426293e821ecfd9ef1a0731df\"}}]")!
        consumer.asyncExpectation = expectation(description: "authenticate")
        authenticator.start()
        waitForExpectations(timeout: 3) { (error) in
            if let error = error {
                XCTFail("\(error)")
            }

            XCTAssertEqual(consumer.finishWithUsername, "1028d66426293e821ecfd9ef1a0731df")
        }
    }
}
