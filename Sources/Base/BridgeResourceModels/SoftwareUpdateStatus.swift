//
//  SoftwareUpdateStatus.swift
//  Pods
//
//  Created by Marcel Dittmann on 22.04.16.
//
//

import Foundation
import Gloss

public enum UpdateState: Int {
    
    case noUpdate, downloading, readyForInstall, installed
}

public struct SoftwareUpdateStatus: JSONDecodable {
    
    public let updatestate: UpdateState?
    
    /**
     Check for update flag of the bridge
     */
    public let checkforupdate: Bool?
    
    /**
     Details of device type specific updates available
     */
    public let devicetypes: SoftwareUpdateStatusDeviceTypes?
    
    /**
     Release Notes Url
    */
    public let url: String?
    
    /**
     Update Text
    */
    public let text: String?
    
    /**
     Flag that turns to true when update is available. Can only be updated when its state is true and it is being set to false. All other transitions are invalid and will return an error.
     Updating this flag constitutes acceptance by the app of notification of the firmware update
     */
    public let notify: Bool?
    
    public init?(json: JSON) {
        
        updatestate = "updatestate" <~~ json
        checkforupdate = "checkforupdate" <~~ json
        devicetypes = "devicetypes" <~~ json
        url = "url" <~~ json
        text = "text" <~~ json
        notify = "notify" <~~ json
        
    }
    
    public func toJSON() -> JSON? {
        
        let json = jsonify([
            "updatestate" ~~> updatestate,
            "checkforupdate" ~~> checkforupdate,
            "devicetypes" ~~> devicetypes,
            "url" ~~> url,
            "text" ~~> text,
            "notify" ~~> notify
            ])
        
        return json
    }
}

extension SoftwareUpdateStatus: Hashable {
    
    public var hashValue: Int {
        
        return 1
    }
}

public func ==(lhs: SoftwareUpdateStatus, rhs: SoftwareUpdateStatus) -> Bool {
    return lhs.updatestate == rhs.updatestate &&
        lhs.checkforupdate == rhs.checkforupdate &&
        lhs.devicetypes == rhs.devicetypes &&
        lhs.url == rhs.url &&
        lhs.text == rhs.text &&
        lhs.notify == rhs.notify
}
