//
//  CreateBridgeAccessController.swift
//  SwiftyHue
//
//  Created by Marcel Dittmann on 08.05.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SwiftyHue

public protocol CreateBridgeAccessControllerDelegate: class {
    
    func bridgeAccessCreated(bridgeAccessConfig: BridgeAccesssConfig)
}

public class CreateBridgeAccessController: UINavigationController {

    public weak var bridgeAccessCreationDelegate: CreateBridgeAccessControllerDelegate?
    
    func bridgeAccessCreated(bridgeAccessConfig: BridgeAccesssConfig) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        bridgeAccessCreationDelegate?.bridgeAccessCreated(bridgeAccessConfig)
    }
}
