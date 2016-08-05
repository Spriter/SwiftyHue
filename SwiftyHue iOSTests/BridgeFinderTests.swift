//
//  BridgeFinderTests.swift
//  SwiftyHue
//
//  Created by Nils Lattek on 28.05.16.
//
//

import XCTest
import Foundation
@testable import SwiftyHue

class BridgeFinderTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTriesMultipleScanners() {
        let validator = TestBadValidator()
        let finder = BridgeFinder(validator: validator, scannerClasses: [TestScanner1.self, TestScanner2.self])
        let consumer = BridgeFinderConsumer()
        finder.delegate = consumer
        consumer.asyncExpectation = expectation(description: "performFind")

        finder.start()

        waitForExpectations(timeout: 1) { (error) in
            if let error = error {
                XCTFail("\(error)")
            }

            XCTAssertNotNil(TestScanner1.calledAt)
            XCTAssertNotNil(TestScanner2.calledAt)
            XCTAssertTrue(TestScanner1.calledAt!.compare(TestScanner2.calledAt!) == ComparisonResult.orderedAscending)
            XCTAssertEqual(consumer.resultBridges!.count, 0)
        }
    }

    func testValidateIps() {
        let validator = TestBadValidator()
        TestScanner1.results = ["127.0.0.1", "192.168.2.1"]
        TestScanner2.results = ["192.168.2.2"]
        let finder = BridgeFinder(validator: validator, scannerClasses: [TestScanner1.self, TestScanner2.self])
        let consumer = BridgeFinderConsumer()
        finder.delegate = consumer
        consumer.asyncExpectation = expectation(description: "performFind")

        finder.start()

        waitForExpectations(timeout: 1) { (error) in
            if let error = error {
                XCTFail("\(error)")
            }
            XCTAssertEqual(validator.calledForIps.count, 3)
            XCTAssertEqual(validator.calledForIps.first!, "192.168.2.1")
            XCTAssertEqual(validator.calledForIps.last!, "192.168.2.2")
            XCTAssertEqual(consumer.resultBridges!.count, 0)
        }
    }

    func testValidateIpsWithSuccess() {
        let validator = TestGoodValidator()
        TestScanner1.results = ["127.0.0.1", "192.168.2.1"]
        TestScanner2.results = ["192.168.2.2"]
        let finder = BridgeFinder(validator: validator, scannerClasses: [TestScanner1.self, TestScanner2.self])
        let consumer = BridgeFinderConsumer()
        finder.delegate = consumer
        consumer.asyncExpectation = expectation(description: "performFind")

        finder.start()

        waitForExpectations(timeout: 1) { (error) in
            if let error = error {
                XCTFail("\(error)")
            }
            XCTAssertEqual(validator.calledForIps.count, 2)
            XCTAssertEqual(validator.calledForIps.first!, "192.168.2.1")
            XCTAssertEqual(validator.calledForIps.last!, "127.0.0.1")
            XCTAssertEqual(consumer.resultBridges!.count, 2)
        }
    }
}
