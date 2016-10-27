//
//  HueBridge.swift
//  HueSDK
//
//  Created by Nils Lattek on 24.04.16.
//  Copyright © 2016 Nils Lattek. All rights reserved.
//

import Foundation

public struct HueBridge {
    public let ip: String
    public let deviceType: String
    public let friendlyName: String
    public let modelDescription: String
    public let modelName: String
    public let serialNumber: String
    public let UDN: String
    public let icons: [HueBridgeIcon]

    public init(ip: String, deviceType: String, friendlyName: String, modelDescription: String, modelName: String, serialNumber: String, UDN: String, icons: [HueBridgeIcon]) {
        self.ip = ip
        self.deviceType = deviceType
        self.friendlyName = friendlyName
        self.modelDescription = modelDescription
        self.modelName = modelName
        self.serialNumber = serialNumber
        self.UDN = UDN
        self.icons = icons
    }
}