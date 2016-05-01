//
//  TestGoodValidator.swift
//  HueSDK
//
//  Created by Nils Lattek on 25.04.16.
//  Copyright © 2016 Nils Lattek. All rights reserved.
//

import Foundation
import SwiftyHue

class TestGoodValidator: BridgeValidator {
    var calledForIps = [String]()

    override func validate(ip: String, success: (bridge: HueBridge) -> Void, failure: (error: NSError) -> Void) {
        calledForIps.append(ip)
        success(bridge: HueBridge(ip: ip, deviceType: "test device", friendlyName: "name", modelDescription: "model", modelName: "model", serialNumber: "serial", UDN: "udn", icons: []))
    }
}