//
//  VerifyBridge.swift
//  HueSDK
//
//  Given an IP-Adress it tries to retrieve more information about the HUE Bridge. 
//
//  Created by Nils Lattek on 24.04.16.
//  Copyright © 2016 Nils Lattek. All rights reserved.
//

import Foundation

class BridgeValidator {
    func validate(_ ip: String, success: @escaping (_ bridge: HueBridge) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        let request = createRequest(ip)
        startRequest(request as URLRequest, success: success, failure: failure)
    }

    private func createRequest(_ ip: String) -> NSMutableURLRequest {
        let url = URL(string: "https://\(ip)/description.xml")!

        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 8

        return request
    }

    private func startRequest(_ request: URLRequest, success: @escaping (_ bridge: HueBridge) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        let task = HueNetwork.urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                failure(error as NSError)
                return
            }

            guard let data = data else {
                failure(NSError(domain: "HueBridgeValidator", code: 500, userInfo: [NSLocalizedDescriptionKey: "No data from bridge received."]))
                return
            }

            // TODO: check specVersion/xmlns and use correct parser
            let parser = BridgeResultParser(xmlData: data, fallbackIP: request.url?.host ?? "")
            parser.parse({ bridge in
                success(bridge)
            }, failure: { error in
                failure(error)
            })
        }
        
        task.resume()
    }
}
