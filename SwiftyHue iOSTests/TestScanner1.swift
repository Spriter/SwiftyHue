//
//  TestScanner1.swift
//  SwiftyHue
//
//  Created by Nils Lattek on 28.05.16.
//
//

@testable import SwiftyHue

class TestScanner1: NSObject, Scanner {
    weak var delegate: ScannerDelegate?
    static var results = [String]()
    static var calledAt: Date?

    required init(delegate: ScannerDelegate? = nil) {
        self.delegate = delegate
        super.init()
    }

    func start() {
        TestScanner1.calledAt = Date()
        delegate?.scanner(self, didFinishWithResults: TestScanner1.results)
    }

    func stop() {
        
    }
}
