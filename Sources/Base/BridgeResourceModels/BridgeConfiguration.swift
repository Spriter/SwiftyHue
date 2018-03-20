//
//  BridgeConfiguration.swift
//  Pods
//
//  Created by Marcel Dittmann on 22.04.16.
//
//

import Foundation
import Gloss

public struct BridgeConfiguration: BridgeResourceDictGenerator, BridgeResource {
    
    public typealias AssociatedBridgeResourceType = BridgeConfiguration;
    
    public var resourceType: BridgeResourceType {
        return .config
    };

    public let identifier: String
    
    /**
     Name of the bridge. This is also its uPnP name, so will reflect the actual uPnP name after any conflicts have been resolved.
    */
    public let name: String
    
    /**
     The current wireless frequency channel used by the bridge. It can take values of 11, 15, 20,25 or 0 if undefined (factory new).
     */
    public let zigbeeChannel: Int?
    
    /**
     The unique bridge id. This is currently generated from the bridge Ethernet mac address.
     */
    public var bridgeId: String {
        
        return identifier
    }
    
    /**
     MAC address of the bridge.
     */
    public let mac: String
    
    /**
     Whether the IP address of the bridge is obtained with DHCP.
     */
    public let dhcp: Bool?
    
    /**
     IP address of the bridge.
     */
    public let ipaddress: String?
    
    /**
     Network mask of the bridge.
     */
    public let netmask: String?
    
    /**
     Gateway IP address of the bridge.
     */
    public let gateway: String?
    
    /**
     IP Address of the proxy server being used. A value of “none” indicates no proxy.
     */
    public let proxyaddress: String?
    
    /**
     Port of the proxy being used by the bridge. If set to 0 then a proxy is not being used.
     */
    public let proxyport: Int?
    
    /**
     Current time stored on the bridge.
     */
    public let UTC: String?
    
    /**
     The local time of the bridge.
     */
    public let localtime: String?
    
    /**
     Timezone of the bridge as OlsenIDs, like "Europe/Amsterdam" or "none" when not configured.
     */
    public let timezone: String?
    
    /**
     This parameter uniquely identifies the hardware model of the bridge (BSB001, BSB002).
     */
    public let modelId: String
    
    /**
     Software version of the bridge.
     */
    public let swVersion: String?
    
    /**
     The version of the hue API in the format <major>.<minor>.<patch>, for example 1.2.1
    */
    public let apiVersion: String
    
    /**
     Contains information related to software updates.
     */
    public let swUpdate: SoftwareUpdateStatus?
    
    /**
     Indicates whether the link button has been pressed within the last 30 seconds.
     */
    public let linkbutton: Bool?
    
    /**
     This indicates whether the bridge is registered to synchronize data with a portal account.
     */
    public let portalServices: Bool?
    
    /**
     portalconnection
     */
    public let portalConnection: String?
    
    /**
     portalstate
     */
    public let portalState: PortalState?
    
    /**
     Indicates if bridge settings are factory new.
     */
    public let factorynew: Bool
    
    /**
     If a bridge backup file has been restored on this bridge from a bridge with a different bridgeid, it will indicate that bridge id, otherwise it will be null.
     */
    public let replacesBridgeId: String?
    
    /**
     backup
     */
    public let backup: Backup?
    
    /**
     A list of whitelisted users
     */
    public let whitelist: [String: WhitelistEntry]?
    
    public init?(json: JSON) {
        
        guard let identifier: String = "bridgeid" <~~ json,
            let name: String = "name" <~~ json,
            let mac: String = "mac" <~~ json,
            let modelid: String = "modelid" <~~ json,
            let swversion: String = "swversion" <~~ json,
            let apiversion: String = "apiversion" <~~ json,
            let factorynew: Bool = "factorynew" <~~ json
        
            else { print("Can't create BridgeConfiguration from JSON:\n \(json)"); return nil }
        
        self.identifier = identifier
        self.name = name
        self.factorynew = factorynew
        self.mac = mac
        self.modelId = modelid
        self.apiVersion = apiversion
        self.swVersion = swversion
        
        self.replacesBridgeId = "replacesbridgeid" <~~ json
        self.zigbeeChannel = "zigbeechannel" <~~ json
        self.dhcp = "dhcp" <~~ json
        self.ipaddress = "ipaddress" <~~ json
        self.netmask = "netmask" <~~ json
        self.gateway = "gateway" <~~ json
        self.proxyaddress = "proxyaddress" <~~ json
        self.proxyport = "proxyport" <~~ json
        self.UTC = "UTC" <~~ json
        self.localtime = "localtime" <~~ json
        self.timezone = "timezone" <~~ json
        self.swUpdate = "swupdate" <~~ json
        self.linkbutton = "linkbutton" <~~ json
        self.portalServices = "portalservices" <~~ json
        self.portalConnection = "portalconnection" <~~ json
        self.portalState = "portalstate" <~~ json
        self.backup = "backup" <~~ json
         
        if let whitelistJSON = json["whitelist"] as? JSON {
            self.whitelist = WhitelistEntry.dictionaryFromResourcesJSON(whitelistJSON)
        } else {
            self.whitelist = nil;
        }
    }
    
    public func toJSON() -> JSON? {
        
        let json = jsonify([
            "bridgeid" ~~> identifier,
            "name" ~~> name,
            "zigbeechannel" ~~> zigbeeChannel,
            "mac" ~~> mac,
            "dhcp" ~~> dhcp,
            "ipaddress" ~~> ipaddress,
            "netmask" ~~> netmask,
            "gateway" ~~> gateway,
            "proxyaddress" ~~> proxyaddress,
            "proxyport" ~~> proxyport,
            "UTC" ~~> UTC,
            "localtime" ~~> localtime,
            "timezone" ~~> timezone,
            "modelid" ~~> modelId,
            "swversion" ~~> swVersion,
            "apiversion" ~~> apiVersion,
            "swupdate" ~~> swUpdate,
            "linkbutton" ~~> linkbutton,
            "portalservices" ~~> portalServices,
            "portalconnection" ~~> portalConnection,
            "portalstate" ~~> portalState,
            "factorynew" ~~> factorynew,
            "replacesbridgeid" ~~> replacesBridgeId,
            "backup" ~~> backup,
            "whitelist" ~~> whitelist,
            ])
        
        return json
    }
}

extension BridgeConfiguration: Hashable {
    
    public var hashValue: Int {
        
        return Int(self.identifier)!
    }
}
public func ==(lhs: BridgeConfiguration, rhs: BridgeConfiguration) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.name == rhs.name &&
        lhs.zigbeeChannel == rhs.zigbeeChannel &&
        lhs.mac == rhs.mac &&
        lhs.dhcp == rhs.dhcp &&
        lhs.ipaddress == rhs.ipaddress &&
        lhs.netmask == rhs.netmask &&
        lhs.gateway == rhs.gateway &&
        lhs.proxyaddress == rhs.proxyaddress &&
        lhs.proxyport == rhs.proxyport &&
        lhs.UTC == rhs.UTC &&
        lhs.localtime == rhs.localtime &&
        lhs.timezone == rhs.timezone &&
        lhs.modelId == rhs.modelId &&
        lhs.swVersion == rhs.swVersion &&
        lhs.apiVersion == rhs.apiVersion &&
        lhs.swUpdate == rhs.swUpdate &&
        lhs.linkbutton == rhs.linkbutton &&
        lhs.portalServices == rhs.portalServices &&
        lhs.portalConnection == rhs.portalConnection &&
        lhs.portalState == rhs.portalState &&
        lhs.factorynew == rhs.factorynew &&
        lhs.replacesBridgeId == rhs.replacesBridgeId &&
        lhs.backup == rhs.backup &&
        (lhs.whitelist ?? [:]) == (rhs.whitelist ?? [:])
}
