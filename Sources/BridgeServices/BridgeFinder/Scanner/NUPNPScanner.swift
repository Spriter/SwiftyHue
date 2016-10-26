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

    required init(delegate: ScannerDelegate? = nil) {
        self.delegate = delegate
        super.init()
    }

    func start() {
        let request = createRequest()
        startRequest(request as URLRequest)
    }

    func stop() {

    }

    private func createRequest() -> URLRequest {
        let url = URL(string: "https://www.meethue.com/api/nupnp")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        return request
    }

    private func startRequest(_ request: URLRequest) {
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let this = self else {
                return
            }

            if error != nil || data == nil {
                this.delegate?.scanner(this, didFinishWithResults: [])
                return
            }

            let ips = this.parseResults(data!)
            this.delegate?.scanner(this, didFinishWithResults: ips)
        }
        
        task.resume()
    }

    private func parseResults(_ data: Data) -> [String] {
        var ips = [String]()

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]] {
                for bridgeJson in json {
                    if let ip = bridgeJson["internalipaddress"] {
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
