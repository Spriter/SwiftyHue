//
//  TestScanner1.swift
//  HueSDK
//
//  Created by Nils Lattek on 25.04.16.
//  Copyright © 2016 Nils Lattek. All rights reserved.
//

import Foundation
import SwiftyHue

class TestScanner1: NSObject, Scanner {
    weak var delegate: ScannerDelegate?
    static var results = [String]()
    static var calledAt: NSDate?

    required init(delegate: ScannerDelegate? = nil) {
        self.delegate = delegate
        super.init()
    }

    func start() {
        TestScanner1.calledAt = NSDate()
        delegate?.scanner(self, didFinishWithResults: TestScanner1.results)
    }

    func stop() {

    }
}