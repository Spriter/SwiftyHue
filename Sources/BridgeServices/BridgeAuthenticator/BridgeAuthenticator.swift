//
//  BridgeAuthenticator.swift
//  Pods
//
//  Created by Nils Lattek on 05.05.16.
//
//

import Foundation

public class BridgeAuthenticator {
    private var authenticationStartedAt: Date?
    private let ip: String
    private let uniqueIdentifier: String
    private let pollingInterval: TimeInterval
    private let timeout: TimeInterval

    public weak var delegate: BridgeAuthenticatorDelegate?

    // convention for uniqueIdentifier format: "my_hue_app#iphone peter"
    public convenience init(bridge: HueBridge, uniqueIdentifier: String) {
        self.init(bridge: bridge, uniqueIdentifier: uniqueIdentifier, pollingInterval: 3, timeout: 30)
    }

    public init(bridge: HueBridge, uniqueIdentifier: String, pollingInterval: TimeInterval, timeout: TimeInterval) {
        self.ip = bridge.ip
        self.uniqueIdentifier = uniqueIdentifier
        self.pollingInterval = pollingInterval
        self.timeout = timeout
    }

    public func start() {
        authenticationStartedAt = Date()
        startRequest()
    }

    private func createRequest() -> URLRequest {
        let url = URL(string: "http://\(ip)/api")!

        let body = ["devicetype": uniqueIdentifier]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])

        return request
    }

    @objc private func startRequest() {
        let request = createRequest()
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error as? NSError {
                self.handleResponse(data, response: response, error: error)
            } else {
                self.handleResponse(data, response: response, error: nil)
            }
            return ()
        }

        task.resume()
    }

    private func startNextRequest(_ ip: String, uniqueIdentifier: String) {
        if abs(authenticationStartedAt!.timeIntervalSinceNow) > timeout {
            DispatchQueue.main.async {
                self.delegate?.bridgeAuthenticatorDidTimeout(self)
            }
            return
        }

        let timer = Timer(timeInterval: pollingInterval, target: self, selector: #selector(BridgeAuthenticator.startRequest), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
    }

    private func handleResponse(_ data: Data?, response: URLResponse?, error: NSError?) {
        if let error = self.parseError(error, data: data) {
            if error.code == 101 {
                let secondsLeft: TimeInterval = timeout - abs(authenticationStartedAt!.timeIntervalSinceNow)
                DispatchQueue.main.async {
                    self.delegate?.bridgeAuthenticatorRequiresLinkButtonPress(self, secondsLeft: secondsLeft)
                }
                self.startNextRequest(self.ip, uniqueIdentifier: self.uniqueIdentifier)
            } else {
                // unknown error
                DispatchQueue.main.async {
                    self.delegate?.bridgeAuthenticator(self, didFailWithError: error)
                }
            }

            return
        }

        self.parseSuccessBody(data!)
    }

    private func parseError(_ error: NSError?, data: Data?) -> NSError? {
        if let error = error {
            return error
        }

        guard let data = data else {
            return NSError(domain: "BridgeAuthenticator", code: 404, userInfo: [NSLocalizedDescriptionKey: "Could not authenticate user (no data)"])
        }

        guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: [String: Any]]] else {
            return NSError(domain: "BridgeAuthenticator", code: 500, userInfo: [NSLocalizedDescriptionKey: "Could not parse result."])
        }

        guard let errorJson = result![0]["error"] else {
            return nil
        }

        let desc = errorJson["description"] as! String
        let error = NSError(domain: "BridgeAuthenticator", code: errorJson["type"] as! Int, userInfo: [NSLocalizedDescriptionKey: desc])
        return error
    }

    private func parseSuccessBody(_ data: Data) {
        let result = try! JSONSerialization.jsonObject(with: data, options: [])
        
        guard let json = result as? [ [String: [String: AnyObject]] ] else {
            let error = NSError(domain: "BridgeAuthenticator", code: 404, userInfo: [NSLocalizedDescriptionKey: "Could not authenticate user (parse error)"])
            DispatchQueue.main.async {
                self.delegate?.bridgeAuthenticator(self, didFailWithError: error)
            }
            return
        }

        let username = json[0]["success"]!["username"] as! String

        DispatchQueue.main.async {
            self.delegate?.bridgeAuthenticator(self, didFinishAuthentication: username)
        }
    }
}
