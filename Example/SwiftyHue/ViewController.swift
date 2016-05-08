//
//  ViewController.swift
//  SwiftyHue
//
//  Created by Marcel Dittmann on 04/21/2016.
//  Copyright (c) 2016 Marcel Dittmann. All rights reserved.
//

import UIKit
import SwiftyHue
import Gloss

class ViewController: UIViewController, BridgeFinderDelegate, BridgeAuthenticatorDelegate {
    
    private let bridgeAccessConfigUserDefaultsKey = "BridgeAccessConfig"
    
    private let bridgeFinder = BridgeFinder()
    private var bridgeAuthenticator: BridgeAuthenticator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let bridgeAccessConfig = readBridgeAccessConfig() {
        
            runTestCode()
            
        } else {
           
            var controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CreateBridgeAccessController") as! CreateBridgeAccessController
            controller.bridgeAccessCreationDelegate = self;

            self.presentViewController(controller, animated: false, completion: nil)
        }
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: BridgeAccessConfig

extension ViewController {
    
    func readBridgeAccessConfig() -> BridgeAccesssConfig? {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let bridgeAccessConfigJSON = userDefaults.objectForKey(bridgeAccessConfigUserDefaultsKey) as? JSON
        
        var bridgeAccessConfig: BridgeAccesssConfig?
        if let bridgeAccessConfigJSON = bridgeAccessConfigJSON {
            
            bridgeAccessConfig = BridgeAccesssConfig(json: bridgeAccessConfigJSON)
        }
        
        return bridgeAccessConfig
    }
    
    func writeBridgeAccessConfig(bridgeAccesssConfig: BridgeAccesssConfig) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let bridgeAccessConfigJSON = bridgeAccesssConfig.toJSON()
        userDefaults.setObject(bridgeAccessConfigJSON, forKey: bridgeAccessConfigUserDefaultsKey)
    }
}

// MARK: CreateBridgeAccessControllerDelegate

extension ViewController: CreateBridgeAccessControllerDelegate {
    
    func bridgeAccessCreated(bridgeAccessConfig: BridgeAccesssConfig) {
        
        writeBridgeAccessConfig(bridgeAccessConfig)
    }
}

// MARK: - Playground
extension ViewController {
    
    func runTestCode() {
        
        //        let bridgeAccesssConfig = BridgeAccesssConfig(bridgeId: "yourBridgeId", ipAddress: "Bridge IP", username: "username")
        
        var bridgeAccessConfig = self.readBridgeAccessConfig()!
        
        var beatManager = BeatManager(bridgeAccesssConfig: bridgeAccessConfig)
        beatManager.setLocalHeartbeatInterval(3, forResourceType: .Lights)
        beatManager.setLocalHeartbeatInterval(3, forResourceType: .Groups)
        beatManager.startHeartbeat()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.lightChanged), name: ResourceCacheUpdateNotification.GroupsUpdated.rawValue, object: nil)
        
        //        var lightState = LightState()
        //        lightState.on = true
        
        //        BridgeSendAPI.updateLightStateForId("324325675tzgztztut1234434334", withLightState: lightState) { (errors) in
        //            print(errors)
        //        }
        
        //        BridgeSendAPI.setLightStateForGroupWithId("huuuuuuu1", withLightState: lightState) { (errors) in
        //
        //            print(errors)
        //        }
        
        //        BridgeSendAPI.createGroupWithName("TestRoom", andType: GroupType.LightGroup, inlcudeLightIds: ["1","2"]) { (errors) in
        //
        //            print(errors)
        //        }
        
        //        BridgeSendAPI.removeGroupWithId("11") { (errors) in
        //
        //            print(errors)
        //        }
        
        //        BridgeSendAPI.updateGroupWithId("11", newName: "TestRoom234", newLightIdentifiers: nil) { (errors) in
        //
        //            print(errors)
        //        }
        
        
        //TestRequester.sharedInstance.requestScenes()
        
        //TestRequester.sharedInstance.requestSchedules()
        
        //        BridgeSendAPI.createSceneWithName("MeineTestScene", inlcudeLightIds: ["1"]) { (errors) in
        //
        //            print(errors)
        //        }
        
        //TestRequester.sharedInstance.requestLights()
        //TestRequester.sharedInstance.getConfig()
        //TestRequester.sharedInstance.requestError()
        
        //        BridgeSendAPI.activateSceneWithIdentifier("14530729836055") { (errors) in
        //            print(errors)
        //        }
        
        //        BridgeSendAPI.recallSceneWithIdentifier("14530729836055", inGroupWithIdentifier: "2") { (errors) in
        //
        //            print(errors)
        //        }
    }
    
    public func lightChanged() {
        
        var cache = BridgeResourcesCacheManager.sharedInstance.cache
        var light = cache.groups["1"]!
        print(light.name)
    }
    
    // MARK: - BridgeFinderDelegate
    
    func bridgeFinder(finder: BridgeFinder, didFinishWithResult bridges: [HueBridge]) {
        print(bridges)
        guard let bridge = bridges.first else {
            return
        }
        
        bridgeAuthenticator = BridgeAuthenticator(bridge: bridge, uniqueIdentifier: "example#simulator")
        bridgeAuthenticator!.delegate = self
        bridgeAuthenticator!.start()
    }
    
    // MARK: - BridgeAuthenticatorDelegate
    
    func bridgeAuthenticatorDidTimeout(authenticator: BridgeAuthenticator) {
        print("Timeout")
    }
    
    func bridgeAuthenticator(authenticator: BridgeAuthenticator, didFailWithError error: NSError) {
        print("Error while authenticating: \(error)")
    }
    
    func bridgeAuthenticatorRequiresLinkButtonPress(authenticator: BridgeAuthenticator) {
        print("Press link button")
    }
    
    func bridgeAuthenticator(authenticator: BridgeAuthenticator, didFinishAuthentication username: String) {
        print("Authenticated, hello \(username)")
    }
}

