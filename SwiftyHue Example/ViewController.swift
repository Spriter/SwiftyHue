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

var swiftyHue: SwiftyHue = SwiftyHue();

class ViewController: UIViewController, BridgeFinderDelegate, BridgeAuthenticatorDelegate {
    
    private let bridgeAccessConfigUserDefaultsKey = "BridgeAccessConfig"
    
    private let bridgeFinder = BridgeFinder()
    private var bridgeAuthenticator: BridgeAuthenticator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swiftyHue.enableLogging(true)
        swiftyHue.setMinLevelForLogMessages(.Info)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destController = segue.destinationViewController as! BridgeResourceTableViewController
        
        if segue.identifier == "LightsSegue" {
            
            destController.resourceTypeToDisplay = .lights
            
        } else if segue.identifier == "GroupsSegue" {
            
            destController.resourceTypeToDisplay = .groups
            
        } else if segue.identifier == "ScenesSegue" {
            
            destController.resourceTypeToDisplay = .scenes
            
        } else if segue.identifier == "SensorsSegue" {
            
            destController.resourceTypeToDisplay = .sensors
            
        } else if segue.identifier == "SchedulesSegue" {
            
            destController.resourceTypeToDisplay = .schedules
            
        } else if segue.identifier == "RulesSegue" {
            
            destController.resourceTypeToDisplay = .rules
            
        } else if segue.identifier == "ConfigSegue" {
            
            destController.resourceTypeToDisplay = .config
        }
    }

}

// MARK: BridgeAccessConfig

extension ViewController {
    
    func readBridgeAccessConfig() -> BridgeAccessConfig? {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let bridgeAccessConfigJSON = userDefaults.objectForKey(bridgeAccessConfigUserDefaultsKey) as? JSON
        
        var bridgeAccessConfig: BridgeAccessConfig?
        if let bridgeAccessConfigJSON = bridgeAccessConfigJSON {
            
            bridgeAccessConfig = BridgeAccessConfig(json: bridgeAccessConfigJSON)
        }
        
        return bridgeAccessConfig
    }
    
    func writeBridgeAccessConfig(bridgeAccessConfig: BridgeAccessConfig) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let bridgeAccessConfigJSON = bridgeAccessConfig.toJSON()
        userDefaults.setObject(bridgeAccessConfigJSON, forKey: bridgeAccessConfigUserDefaultsKey)
    }
}

// MARK: CreateBridgeAccessControllerDelegate

extension ViewController: CreateBridgeAccessControllerDelegate {
    
    func bridgeAccessCreated(bridgeAccessConfig: BridgeAccessConfig) {
        
        writeBridgeAccessConfig(bridgeAccessConfig)
    }
}

// MARK: - Playground
extension ViewController {
    
    func runTestCode() {
        
        let bridgeAccessConfig = self.readBridgeAccessConfig()!
        swiftyHue.setBridgeAccessConfig(bridgeAccessConfig)
        swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .lights)
        swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .groups)
       swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .rules)
        swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .scenes)
        swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .schedules)
        swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .sensors)
        swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .config)
        swiftyHue.startHeartbeat();
        
//        var lightState = LightState()
//        lightState.on = false;
//        swiftyHue.bridgeSendAPI.setLightStateForGroupWithId("1", withLightState: lightState) { (errors) in
//            
//            print(errors)
//        }
        
        //        var beatManager = BeatManager(bridgeAccessConfig: bridgeAccessConfig)
//        beatManager.setLocalHeartbeatInterval(3, forResourceType: .Lights)
//        beatManager.setLocalHeartbeatInterval(3, forResourceType: .Groups)
//        beatManager.setLocalHeartbeatInterval(3, forResourceType: .Rules)
//        beatManager.setLocalHeartbeatInterval(3, forResourceType: .Scenes)
//        beatManager.setLocalHeartbeatInterval(3, forResourceType: .Schedules)
//        beatManager.setLocalHeartbeatInterval(3, forResourceType: .Sensors)
//        beatManager.setLocalHeartbeatInterval(3, forResourceType: .Config)
//        
//        beatManager.startHeartbeat()
//                
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.lightChanged), name: ResourceCacheUpdateNotification.lightsUpdated.rawValue, object: nil)
        
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
        
        //        let xy = Utilities.calculateXY(UIColor.greenColor(), forModel: "LST001")
        //        
        //        var lightState = LightState()
        //        lightState.on = true
        //        lightState.xy = [Float(xy.x), Float(xy.y)]
        //        lightState.brightness = 254
        //        
        //        BridgeSendAPI.updateLightStateForId("6", withLightState: lightState) { (errors) in
        //            print(errors)
        //        }
    }
    
    public func lightChanged() {
        
        print("Changed")
        
//        var cache = BridgeResourcesCacheManager.sharedInstance.cache
//        var light = cache.groups["1"]!
//        print(light.name)
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

