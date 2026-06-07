//
//  SoftwareUpdateStatus.swift
//  Pods
//
//  Created by Marcel Dittmann on 22.04.16.
//
//

import Foundation

public enum UpdateState: Int, Codable {
    case noUpdate, downloading, readyForInstall, installed
}

public struct SoftwareUpdateStatus: Codable {

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

    public init?(json: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: json),
              let decoded = try? JSONDecoder().decode(SoftwareUpdateStatus.self, from: data) else {
            return nil
        }
        self = decoded
    }

    public func toJSON() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let object = try? JSONSerialization.jsonObject(with: data),
              let json = object as? [String: Any] else {
            return nil
        }
        return json
    }
}

extension SoftwareUpdateStatus: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(1)
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
