//
//  BridgeConfiguration.swift
//  Pods
//
//  Created by Marcel Dittmann on 22.04.16.
//
//

import Foundation

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
        
        guard
            let identifier = json["bridgeid"] as? String,
            let name = json["name"] as? String,
            let mac = json["mac"] as? String,
            let modelid = json["modelid"] as? String,
            let swversion = json["swversion"] as? String,
            let apiversion = json["apiversion"] as? String,
            let factorynew = json["factorynew"] as? Bool
        else {
            print("Can't create BridgeConfiguration from JSON:\n \(json)")
            return nil
        }
        
        self.identifier = identifier
        self.name = name
        self.factorynew = factorynew
        self.mac = mac
        self.modelId = modelid
        self.apiVersion = apiversion
        self.swVersion = swversion
        
        self.replacesBridgeId = json["replacesbridgeid"] as? String
        self.zigbeeChannel = json["zigbeechannel"] as? Int
        self.dhcp = json["dhcp"] as? Bool
        self.ipaddress = json["ipaddress"] as? String
        self.netmask = json["netmask"] as? String
        self.gateway = json["gateway"] as? String
        self.proxyaddress = json["proxyaddress"] as? String
        self.proxyport = json["proxyport"] as? Int
        self.UTC = json["UTC"] as? String
        self.localtime = json["localtime"] as? String
        self.timezone = json["timezone"] as? String
        if let swUpdateJSON = json["swupdate"] as? JSON {
            self.swUpdate = SoftwareUpdateStatus(json: swUpdateJSON)
        } else {
            self.swUpdate = nil
        }
        self.linkbutton = json["linkbutton"] as? Bool
        self.portalServices = json["portalservices"] as? Bool
        self.portalConnection = json["portalconnection"] as? String
        if let portalStateJSON = json["portalstate"] as? JSON {
            self.portalState = PortalState(json: portalStateJSON)
        } else {
            self.portalState = nil
        }
        if let backupJSON = json["backup"] as? JSON {
            self.backup = Backup(json: backupJSON)
        } else {
            self.backup = nil
        }
         
        if let whitelistJSON = json["whitelist"] as? JSON {
            self.whitelist = WhitelistEntry.dictionaryFromResourcesJSON(whitelistJSON)
        } else {
            self.whitelist = nil;
        }
    }
    
    public func toJSON() -> JSON? {
        var json: JSON = [
            "bridgeid": identifier,
            "name": name,
            "mac": mac,
            "modelid": modelId,
            "apiversion": apiVersion,
            "factorynew": factorynew
        ]
        json["swversion"] = swVersion
        json["zigbeechannel"] = zigbeeChannel
        json["dhcp"] = dhcp
        json["ipaddress"] = ipaddress
        json["netmask"] = netmask
        json["gateway"] = gateway
        json["proxyaddress"] = proxyaddress
        json["proxyport"] = proxyport
        json["UTC"] = UTC
        json["localtime"] = localtime
        json["timezone"] = timezone
        json["swupdate"] = swUpdate?.toJSON()
        json["linkbutton"] = linkbutton
        json["portalservices"] = portalServices
        json["portalconnection"] = portalConnection
        json["portalstate"] = portalState?.toJSON()
        json["replacesbridgeid"] = replacesBridgeId
        json["backup"] = backup?.toJSON()
        if let whitelist {
            var whitelistJSON: JSON = [:]
            for (key, entry) in whitelist {
                whitelistJSON[key] = entry.toJSON()
            }
            json["whitelist"] = whitelistJSON
        }
        return json
    }
}

extension BridgeConfiguration: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(Int(self.identifier)!)
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
