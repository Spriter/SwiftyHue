//
//  BridgeFinder.swift
//  HueSDK
//
//  Created by Nils Lattek on 24.04.16.
//  Copyright © 2016 Nils Lattek. All rights reserved.
//

import Foundation
//import Log

/// Use this class to find HueBridges on the current network.
public class BridgeFinder: NSObject, ScannerDelegate {
    private var foundBridges = [HueBridge]()
    private let allScannerClasses: [Scanner.Type]
    private var remainingScannerClasses: [Scanner.Type] = []
    private var currentScanner: Scanner?
    private let validator: BridgeValidator
    public weak var delegate: BridgeFinderDelegate?

    public override convenience init() {
        // The recommended search order from Philips is SSDPScanner, NUPNPScanner,
        // IPScanner (not implemented currently).
        self.init(validator: BridgeValidator(), scannerClasses: [SSDPScanner.self, NUPNPScanner.self])
    }

    init(validator: BridgeValidator, scannerClasses: [Scanner.Type]) {
        self.validator = validator
        // Given the recommened order from Phillips and in order to avoid
        // dealing with checking the length of this array using remove(at:0)
        // so we don't get an IndexError, we are going to use popLast() -> T?
        // to pull the items out of it. To do that and maintain the
        // recommened order from Phillips we need to reverse the array as we
        // declared it's contents in the recommended order.
        self.allScannerClasses = scannerClasses.reversed()
        super.init()
    }

    /// Start scanning, make sure to assign a delegate to get notified about the results.
    public func start() {
        remainingScannerClasses = allScannerClasses
        startNextScanner()
    }

    private func startNextScanner() {
        guard let scannerClass = remainingScannerClasses.popLast() else {
            // all scanners finished, no bridges found
            DispatchQueue.main.async {
                self.delegate?.bridgeFinder(self, didFinishWithResult: self.foundBridges)
            }
            return
        }

        //Log.trace("Scanner started: \(scannerClass)")
        currentScanner = scannerClass.init(delegate: self)
        currentScanner?.start()
    }

    private func validateBridges(_ ips: [String]) {
        // create mutable copy, use recursion to check if every bridge has been validated
        var ips = ips

        guard let ip = ips.popLast() else {
            // all ips validated for current scanner
            ipValidationFinished()
            return
        }

        validator.validate(ip, success: { [weak self] (bridge) in
            if let this = self {
                this.foundBridges.append(bridge)
                this.validateBridges(ips)
            }
        }, failure: { [weak self] (error) in
            if let this = self {
                this.validateBridges(ips)
            }
        })
    }

    private func ipValidationFinished() {
        if foundBridges.count == 0 {
            // no bridges found, continue with next scanner
            startNextScanner()
        } else {
            DispatchQueue.main.async {
                self.delegate?.bridgeFinder(self, didFinishWithResult: self.foundBridges)
            }
        }
    }

    // MARK: - ScannerDelegate

    func scanner(_ scanner: Scanner, didFinishWithResults ips: [String]) {
        //Log.trace("Scanner finished: \(scanner) with result count: \(ips.count)")
        validateBridges(ips)
    }
}
