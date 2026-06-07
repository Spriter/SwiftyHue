//
//  NUPNPScanner.swift
//  HueSDK
//
//  Created by Nils Lattek on 24.04.16.
//  Copyright © 2016 Nils Lattek. All rights reserved.
//

import Foundation

class NUPNPScanner: NSObject, Scanner {
    weak var delegate: ScannerDelegate?
    private var finished = false

    required init(delegate: ScannerDelegate? = nil) {
        self.delegate = delegate
        super.init()
    }

    func start() {
        finished = false
        let request = createRequest()
        startRequest(request as URLRequest)
        scheduleTimeout()
    }

    func stop() {
        finish(with: [])
    }

    private func createRequest() -> URLRequest {
        let url = URL(string: "https://discovery.meethue.com")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 8

        return request
    }

    private func startRequest(_ request: URLRequest) {
        let task = HueNetwork.urlSession.dataTask(with: request) { [weak self] (data, response, error) in
            guard let this = self else {
                return
            }

            if error != nil || data == nil {
                this.finish(with: [])
                return
            }

            let ips = this.parseResults(data!)
            this.finish(with: ips)
        }
        
        task.resume()
    }

    private func scheduleTimeout() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) { [weak self] in
            self?.finish(with: [])
        }
    }

    private func finish(with ips: [String]) {
        if finished { return }
        finished = true
        delegate?.scanner(self, didFinishWithResults: ips)
    }

    private func parseResults(_ data: Data) -> [String] {
        var ips = [String]()

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                for bridgeJson in json {
                    if let ip = bridgeJson["internalipaddress"] as? String {
                        ips.append(ip)
                    }
                }
            }


        } catch let error as NSError {
            print("Error while parsing nupnp results: \(error)")
        }

        return ips
    }
}
