//
//  BridgeAuthenticatorDelegate.swift
//  Pods
//
//  Created by Nils Lattek on 05.05.16.
//
//

import Foundation

public protocol BridgeAuthenticatorDelegate: class {
    func bridgeAuthenticator(authenticator: BridgeAuthenticator, didFinishAuthentication username: String)
    func bridgeAuthenticator(authenticator: BridgeAuthenticator, didFailWithError error: NSError)
    // you should now ask the user to press the link button
    func bridgeAuthenticatorRequiresLinkButtonPress(authenticator: BridgeAuthenticator)
    // user did not press the link button in time, you restart the process and try again
    func bridgeAuthenticatorDidTimeout(authenticator: BridgeAuthenticator)
}