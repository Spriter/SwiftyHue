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
    
    public typealias BridgeResourceType = BridgeConfiguration;
    
    public let identifier: String
    
    /**
     Name of the bridge. This is also its uPnP name, so will reflect the actual uPnP name after any conflicts have been resolved.
    */
    public let name: String
    
    /**
     The current wireless frequency channel used by the bridge. It can take values of 11, 15, 20,25 or 0 if undefined (factory new).
     */
    public let zigbeechannel: Int?
    
    /**
     The unique bridge id. This is currently generated from the bridge Ethernet mac address.
     */
    public var bridgeid: String? {
        
        return identifier
    }
    
    /**
     MAC address of the bridge.
     */
    public let mac: String?
    
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
    public let localtime: NSDate?
    
    /**
     Timezone of the bridge as OlsenIDs, like "Europe/Amsterdam" or "none" when not configured.
     */
    public let timezone: String?
    
    /**
     This parameter uniquely identifies the hardware model of the bridge (BSB001, BSB002).
     */
    public let modelid: String?
    
    /**
     Software version of the bridge.
     */
    public let swversion: String?
    
    /**
     The version of the hue API in the format <major>.<minor>.<patch>, for example 1.2.1
    */
    public let apiversion: String?
    
    /**
     Contains information related to software updates.
     */
    public let swupdate: SoftwareUpdateStatus?
    
    /**
     Indicates whether the link button has been pressed within the last 30 seconds.
     */
    public let linkbutton: Bool?
    
    /**
     This indicates whether the bridge is registered to synchronize data with a portal account.
     */
    public let portalservices: Bool?
    
    /**
     portalconnection
     */
    public let portalconnection: String?
    
    /**
     portalstate
     */
    public let portalstate: PortalState?
    
    /**
     Indicates if bridge settings are factory new.
     */
    public let factorynew: Bool?
    
    /**
     If a bridge backup file has been restored on this bridge from a bridge with a different bridgeid, it will indicate that bridge id, otherwise it will be null.
     */
    public let replacesbridgeid: String?
    
    /**
     backup
     */
    public let backup: Backup?
    
    /**
     A list of whitelisted users
     */
    public let whitelist: [String: WhitelistEntry]?
    
    public init?(json: JSON) {
        
        let dateFormatter = NSDateFormatter.hueApiDateFormatter
        
   
        guard let identifier: String = "bridgeid" <~~ json,
            let name: String = "name" <~~ json
            else { return nil }
        
        self.identifier = identifier
        self.name = name
        
        zigbeechannel = "zigbeechannel" <~~ json
        mac = "mac" <~~ json
        dhcp = "dhcp" <~~ json
        ipaddress = "ipaddress" <~~ json
        netmask = "netmask" <~~ json
        gateway = "gateway" <~~ json
        proxyaddress = "proxyaddress" <~~ json
        proxyport = "proxyport" <~~ json
        UTC = "UTC" <~~ json
        localtime = Decoder.decodeDate("localtime", dateFormatter:dateFormatter)(json)
        timezone = "timezone" <~~ json
        modelid = "modelid" <~~ json
        swversion = "swversion" <~~ json
        apiversion = "apiversion" <~~ json
        swupdate = "swupdate" <~~ json
        linkbutton = "linkbutton" <~~ json
        portalservices = "portalservices" <~~ json
        portalconnection = "portalconnection" <~~ json
        portalstate = "portalstate" <~~ json
        factorynew = "factorynew" <~~ json
        replacesbridgeid = "replacesbridgeid" <~~ json
        backup = "backup" <~~ json
        
        if let whitelistJSON = json["whitelist"] as? JSON {
            
            self.whitelist = WhitelistEntry.dictionaryFromResourcesJSON(whitelistJSON)
            
        } else {
            
            self.whitelist = nil;
        }
        
    }
    
    public func toJSON() -> JSON? {
        
        return [:]

    }
}