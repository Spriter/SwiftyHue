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
    
    func bridgeAccessCreated(bridgeAccessConfig: BridgeAccessConfig)
}

public class CreateBridgeAccessController: UINavigationController {

    public weak var bridgeAccessCreationDelegate: CreateBridgeAccessControllerDelegate?
    
    func bridgeAccessCreated(bridgeAccessConfig: BridgeAccessConfig) {
        
        dismissViewControllerAnimated(true, completion: nil)
        bridgeAccessCreationDelegate?.bridgeAccessCreated(bridgeAccessConfig)
    }
}
