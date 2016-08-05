//
//  TestScanner2.swift
//  SwiftyHue
//
//  Created by Nils Lattek on 28.05.16.
//
//

@testable import SwiftyHue

class TestScanner2: NSObject, Scanner {
    weak var delegate: ScannerDelegate?
    static var results = [String]()
    static var calledAt: Date?

    required init(delegate: ScannerDelegate? = nil) {
        self.delegate = delegate
        super.init()
    }

    func start() {
        TestScanner2.calledAt = Date()
        delegate?.scanner(self, didFinishWithResults: TestScanner2.results)
    }

    func stop() {

    }
}
