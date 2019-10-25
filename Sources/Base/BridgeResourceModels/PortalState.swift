//
//  PortalState.swift
//  Pods
//
//  Created by Marcel Dittmann on 22.04.16.
//
//

import Foundation
import Gloss

public enum PortalStateCommunication: String {
    
    case connected, connecting, disconnected, unknown
}

public struct PortalState: JSONDecodable {
    
    /**
     The bridge is signed on the portal
     */
    public let signedon: Bool?
    
    /**
     The bridge is able to send messages to the portal
     */
    public let incoming: Bool?
    
    /**
     The bridge is able to recieve messages from the portal
     */
    public let outgoing: Bool?
    
    /**
     The bridge is communicating with SmartPortal
     */
    public let communication: PortalStateCommunication?
    
    public init?(json: JSON) {
        
        signedon = "signedon" <~~ json
        incoming = "incoming" <~~ json
        outgoing = "outgoing" <~~ json
        communication = "communication" <~~ json
        
    }
    
    public func toJSON() -> JSON? {
        
        let json = jsonify([
            "signedon" ~~> signedon,
            "incoming" ~~> incoming,
            "outgoing" ~~> outgoing,
            "communication" ~~> communication
            ])
        
        return json
    }
}

extension PortalState: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(1)
    }
}

public func ==(lhs: PortalState, rhs: PortalState) -> Bool {
    return lhs.signedon == rhs.signedon &&
        lhs.incoming == rhs.incoming &&
        lhs.outgoing == rhs.outgoing &&
        lhs.communication == rhs.communication
}
