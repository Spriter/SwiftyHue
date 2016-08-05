//
//  File.swift
//  SwiftyHue
//
//  Created by Nils Lattek on 28.05.16.
//
//

import Foundation
@testable import SwiftyHue

class TestBadValidator: BridgeValidator {
    var calledForIps = [String]()

    override func validate(_ ip: String, success: (bridge: HueBridge) -> Void, failure: (error: NSError) -> Void) {
        calledForIps.append(ip)
        failure(error: NSError(domain: "test", code: 500, userInfo: [NSLocalizedDescriptionKey: "Validation always fails"]))
    }
}

