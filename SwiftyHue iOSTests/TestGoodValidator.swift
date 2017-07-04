//
//  TestGoodValidator.swift
//  SwiftyHue
//
//  Created by Nils Lattek on 28.05.16.
//
//

import Foundation
@testable import SwiftyHue

class TestGoodValidator: BridgeValidator {
    var calledForIps = [String]()

    override func validate(_ ip: String, success: (bridge: HueBridge) -> Void, failure: (error: NSError) -> Void) {
        calledForIps.append(ip)
        success(bridge: HueBridge(ip: ip, deviceType: "test device", friendlyName: "name", modelDescription: "model", modelName: "model", serialNumber: "serial", UDN: "udn", icons: []))
    }
}
