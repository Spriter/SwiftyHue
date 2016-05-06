//
//  BridgeAccessConfig.swift
//  Pods
//
//  Created by Marcel Dittmann on 06.05.16.
//
//

import Foundation

public struct BridgeAccesssConfig {
    
    let bridgeId: String;
    let ipAddress: String;
    let username: String;
    
    public init(bridgeId: String, ipAddress: String, username: String) {
    
        self.bridgeId = bridgeId;
        self.ipAddress = ipAddress;
        self.username = username;
        
    }
}