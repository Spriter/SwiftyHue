//
//  SSDPScanner.swift
//  HueSDK
//
//  Created by Nils Lattek on 24.04.16.
//  Copyright © 2016 Nils Lattek. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class SSDPScanner: NSObject, Scanner, AsyncUdpSocketDelegate {
    private let ssdpSocket: AsyncUdpSocket
    private var results = [String]()
    weak var delegate: ScannerDelegate?

    required init(delegate: ScannerDelegate? = nil) {
        ssdpSocket = AsyncUdpSocket(delegate: nil)
        self.delegate = delegate
        super.init()
        ssdpSocket.setDelegate(self)
    }

    func start() {
        do {
            try ssdpSocket.enableBroadcast(true)
            let searchData = "M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMan: \"ssdp:discover\"\r\nST: ssdp:all\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)
            let host = "239.255.255.250"
            let port: UInt16 = 1900
            // listen 102 error: https://github.com/robbiehanson/CocoaAsyncSocket/issues/376
            try ssdpSocket.bindToPort(0)
            ssdpSocket.sendData(searchData, toHost: host, port: port, withTimeout: 5, tag: 1)
            let receiveTimeout: NSTimeInterval = 5
            ssdpSocket.receiveWithTimeout(receiveTimeout, tag: 1)
            NSTimer.scheduledTimerWithTimeInterval(receiveTimeout, target: self, selector: #selector(SSDPScanner.stop), userInfo: self, repeats: false)

        } catch let error as NSError {
            print("Exception: \(error)")
        }
    }

    @objc func stop() {
        ssdpSocket.close()
        delegate?.scanner(self, didFinishWithResults: results)
    }

    // MARK: - AsyncUdpSocketDelegate

    func onUdpSocket(sock: AsyncUdpSocket!, didReceiveData data: NSData!, withTag tag: Int, fromHost host: String!, port: UInt16) -> Bool {
        guard let result = NSString(data: data, encoding: NSASCIIStringEncoding) else {
            print("Could not decode ssdp data")
            return true
        }

        if result.containsString("IpBridge") {
            results.append(host)
        }
        
        return true
    }
}