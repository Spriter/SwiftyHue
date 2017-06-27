//
//  BridgeAccessConfig.swift
//  Pods
//
//  Created by Marcel Dittmann on 06.05.16.
//
//

import Foundation
import Gloss

public struct BridgeAccessConfig: Gloss.Decodable, Gloss.Encodable {
    
    public let bridgeId: String;
    public let ipAddress: String;
    public let username: String;
    
    public init(bridgeId: String, ipAddress: String, username: String) {
    
        self.bridgeId = bridgeId;
        self.ipAddress = ipAddress;
        self.username = username;
        
    }
    
    public init?(json: JSON) {
        
        guard let bridgeId: String = "id" <~~ json,
            let ipAddress: String = "ipaddress" <~~ json,
            let username: String = "username" <~~ json
            
            else { return nil }
        
        self.bridgeId = bridgeId
        self.ipAddress = ipAddress
        self.username = username
        
    }
    
    public func toJSON() -> JSON? {
        
        let json = jsonify([
            "id" ~~> bridgeId,
            "ipaddress" ~~> ipAddress,
            "username" ~~> username
            ])
        
        return json
    }
}
