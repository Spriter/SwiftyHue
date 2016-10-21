//
//  SSDPScanner.swift
//  HueSDK
//
//  Created by Nils Lattek on 24.04.16.
//  Copyright © 2016 Nils Lattek. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class SSDPScanner: NSObject, Scanner, GCDAsyncUdpSocketDelegate {
    private let ssdpSocket: GCDAsyncUdpSocket
    private let delegateQueue = DispatchQueue(label: "com.blowfishlab.SwiftyHue.ssdpscanner")
    private var results = Set<String>()
    weak var delegate: ScannerDelegate?

    required init(delegate: ScannerDelegate? = nil) {
        self.delegate = delegate
        ssdpSocket = GCDAsyncUdpSocket()
        super.init()
        ssdpSocket.setDelegate(self, delegateQueue: delegateQueue)
    }

    func start() {
        do {
            try ssdpSocket.enableBroadcast(true)
            let searchData = "M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\nMan: \"ssdp:discover\"\r\nST: ssdp:all\r\n\r\n".data(using: .utf8)!
            let host = "239.255.255.250"
            let port: UInt16 = 1900
            // listen 102 error: https://github.com/robbiehanson/CocoaAsyncSocket/issues/376
            try ssdpSocket.bind(toPort: 0)

            ssdpSocket.send(searchData, toHost: host, port: port, withTimeout: 5, tag: 1)
            try ssdpSocket.beginReceiving()

            let receiveTimeout: TimeInterval = 5
            Timer.scheduledTimer(timeInterval: receiveTimeout, target: self, selector: #selector(SSDPScanner.stop), userInfo: self, repeats: false)

        } catch let error as NSError {
            print("Exception: \(error)")
        }
    }

    @objc func stop() {
        ssdpSocket.close()
        let ips = Array(results)
        delegate?.scanner(self, didFinishWithResults: ips)
    }

    // MARK: - GCDAsyncUdpSocketDelegate
    
    func udpSocket(_ sock: GCDAsyncUdpSocket!, didReceive data: Data!, fromAddress address: Data!, withFilterContext: Any?){
        guard let result = String(data: data, encoding:.ascii) else {
            print("Could not decode ssdp data")
            return
        }

        if result.contains("IpBridge") {
            var host: NSString?
            var port: UInt16 = 0

            GCDAsyncUdpSocket.getHost(&host, port: &port, fromAddress: address)
            if let host = host as? String{
                results.insert(host)
            }
        }
    }
}
