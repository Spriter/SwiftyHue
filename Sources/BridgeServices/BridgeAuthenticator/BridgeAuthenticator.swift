//
//  BridgeAuthenticator.swift
//  Pods
//
//  Created by Nils Lattek on 05.05.16.
//
//

import Foundation

public class BridgeAuthenticator {
    private var authenticationStartedAt: NSDate?
    private let ip: String
    private let uniqueIdentifier: String
    private let pollingInterval: NSTimeInterval
    private let timeout: NSTimeInterval
    private var didInformDelegateAboutLinkButton = false

    public weak var delegate: BridgeAuthenticatorDelegate?

    // convention for uniqueIdentifier format: "my_hue_app#iphone peter"
    public convenience init(bridge: HueBridge, uniqueIdentifier: String) {
        self.init(bridge: bridge, uniqueIdentifier: uniqueIdentifier, pollingInterval: 3, timeout: 30)
    }

    init(bridge: HueBridge, uniqueIdentifier: String, pollingInterval: NSTimeInterval, timeout: NSTimeInterval) {
        self.ip = bridge.ip
        self.uniqueIdentifier = uniqueIdentifier
        self.pollingInterval = pollingInterval
        self.timeout = timeout
    }

    public func start() {
        didInformDelegateAboutLinkButton = false
        authenticationStartedAt = NSDate()
        startRequest()
    }

    private func createRequest() -> NSMutableURLRequest {
        let url = NSURL(string: "http://\(ip)/api")!

        let body = ["devicetype": uniqueIdentifier]

        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(body, options: [])

        return request
    }

    @objc private func startRequest() {
        let request = createRequest()
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            self.handleResponse(data, response: response, error: error)
        }

        task.resume()
    }

    private func startNextRequest(ip: String, uniqueIdentifier: String) {
        if abs(authenticationStartedAt!.timeIntervalSinceNow) > timeout {
            dispatch_async(dispatch_get_main_queue()) {
                self.delegate?.bridgeAuthenticatorDidTimeout(self)
            }
            return
        }

        let timer = NSTimer(timeInterval: pollingInterval, target: self, selector: #selector(BridgeAuthenticator.startRequest), userInfo: nil, repeats: false)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }

    private func handleResponse(data: NSData?, response: NSURLResponse?, error: NSError?) {
        if let error = self.parseError(error, data: data) {
            if error.code == 101 && !didInformDelegateAboutLinkButton {
                // user needs to press the link button
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.bridgeAuthenticatorRequiresLinkButtonPress(self)
                }
                didInformDelegateAboutLinkButton = true
                self.startNextRequest(self.ip, uniqueIdentifier: self.uniqueIdentifier)
            } else if error.code == 101 {
                // continue polling for link button
                self.startNextRequest(self.ip, uniqueIdentifier: self.uniqueIdentifier)
            } else {
                // unknown error
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.bridgeAuthenticator(self, didFailWithError: error)
                }
            }

            return
        }

        self.parseSuccessBody(data!)
    }

    private func parseError(error: NSError?, data: NSData?) -> NSError? {
        if let error = error {
            return error
        }

        guard let data = data else {
            return NSError(domain: "BridgeAuthenticator", code: 404, userInfo: [NSLocalizedDescriptionKey: "Could not authenticate user (no data)"])
        }

        guard let result = try? NSJSONSerialization.JSONObjectWithData(data, options: []) else {
            return NSError(domain: "BridgeAuthenticator", code: 500, userInfo: [NSLocalizedDescriptionKey: "Could not parse result."])
        }

        guard let errorJson = result[0]["error"] as? [String: AnyObject] else {
            return nil
        }

        let desc = errorJson["description"] as! String
        let error = NSError(domain: "BridgeAuthenticator", code: errorJson["type"] as! Int, userInfo: [NSLocalizedDescriptionKey: desc])
        return error
    }

    private func parseSuccessBody(data: NSData) {
        let result = try! NSJSONSerialization.JSONObjectWithData(data, options: [])
        
        guard let json = result as? [ [String: [String: AnyObject]] ] else {
            let error = NSError(domain: "BridgeAuthenticator", code: 404, userInfo: [NSLocalizedDescriptionKey: "Could not authenticate user (parse error)"])
            dispatch_async(dispatch_get_main_queue()) {
                self.delegate?.bridgeAuthenticator(self, didFailWithError: error)
            }
            return
        }

        let username = json[0]["success"]!["username"] as! String

        dispatch_async(dispatch_get_main_queue()) {
            self.delegate?.bridgeAuthenticator(self, didFinishAuthentication: username)
        }
    }
}