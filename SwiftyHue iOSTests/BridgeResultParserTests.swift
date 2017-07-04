//
//  BridgeResultParserTests.swift
//  SwiftyHue
//
//  Created by Nils Lattek on 28.05.16.
//
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
        let path = Bundle(for: BridgeResultParserTests.self).path(forResource: "bridge_response", ofType: "xml")!
        let xml = try! Data(contentsOf: URL(fileURLWithPath: path))
        let parser = BridgeResultParser(xmlData: xml)

        let asyncExpectation = expectation(description: "parseBridgeXML")
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

        self.waitForExpectations(timeout: 2, handler: nil)
    }
    
}
