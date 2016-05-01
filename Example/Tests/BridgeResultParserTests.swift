//
//  BridgeResultParserTests.swift
//  HueSDK
//
//  Created by Nils Lattek on 24.04.16.
//  Copyright © 2016 Nils Lattek. All rights reserved.
//

import XCTest
@testable import SwiftyHue

class BridgeResultParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerform() {
        let xml = NSData(contentsOfFile: NSBundle(forClass: BridgeResultParserTests.self).pathForResource("bridge_response", ofType: "xml")!)!
        let parser = BridgeResultParser(xmlData: xml)
    
        let asyncExpectation = expectationWithDescription("parseBridgeXML")
        parser.parse({ (bridge) in
            XCTAssertEqual(bridge.ip, "192.168.1.130")
            XCTAssertEqual(bridge.deviceType, "urn:schemas-upnp-org:device:Basic:1")
            XCTAssertEqual(bridge.friendlyName, "Philips hue (192.168.1.130)")
            XCTAssertEqual(bridge.modelDescription, "Philips hue Personal Wireless Lighting")
            XCTAssertEqual(bridge.modelName, "Philips hue bridge 2012")
            XCTAssertEqual(bridge.serialNumber, "001788102201")
            XCTAssertEqual(bridge.UDN, "uuid:2f402f80-da50-11e1-9b23-001788102201")
            XCTAssertEqual(bridge.icons.count, 2)
            XCTAssertEqual(bridge.icons.first?.mimetype, "image/png")
            XCTAssertEqual(bridge.icons.first?.height, 48)
            XCTAssertEqual(bridge.icons.first?.width, 48)
            XCTAssertEqual(bridge.icons.first?.name, "hue_logo_0.png")
            asyncExpectation.fulfill()
        }, failure: { (error) in

        })

        self.waitForExpectationsWithTimeout(2, handler: nil)
    }
    
}
