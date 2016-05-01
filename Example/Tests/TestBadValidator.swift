//
//  TestValidator.swift
//  HueSDK
//
//  Created by Nils Lattek on 25.04.16.
//  Copyright © 2016 Nils Lattek. All rights reserved.
//

import Foundation
import SwiftyHue

class TestBadValidator: BridgeValidator {
    var calledForIps = [String]()

    override func validate(ip: String, success: (bridge: HueBridge) -> Void, failure: (error: NSError) -> Void) {
        calledForIps.append(ip)
        failure(error: NSError(domain: "test", code: 500, userInfo: [NSLocalizedDescriptionKey: "Validation always fails"]))
    }
}