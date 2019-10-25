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
    
    fileprivate let bridgeAccessConfigUserDefaultsKey = "BridgeAccessConfig"
    
    fileprivate let bridgeFinder = BridgeFinder()
    fileprivate var bridgeAuthenticator: BridgeAuthenticator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swiftyHue.enableLogging(true)
        //swiftyHue.setMinLevelForLogMessages(.info)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if readBridgeAccessConfig() != nil {
        
            runTestCode()
            
        } else {
           
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateBridgeAccessController") as! CreateBridgeAccessController
            controller.bridgeAccessCreationDelegate = self;

            self.present(controller, animated: false, completion: nil)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
        let destController = segue.destination as! BridgeResourceTableViewController
        
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
        
        let userDefaults = UserDefaults.standard
        let bridgeAccessConfigJSON = userDefaults.object(forKey: bridgeAccessConfigUserDefaultsKey) as? JSON
        
        var bridgeAccessConfig: BridgeAccessConfig?
        if let bridgeAccessConfigJSON = bridgeAccessConfigJSON {
            
            bridgeAccessConfig = BridgeAccessConfig(json: bridgeAccessConfigJSON)
        }
        
        return bridgeAccessConfig
    }
    
    func writeBridgeAccessConfig(bridgeAccessConfig: BridgeAccessConfig) {
        
        let userDefaults = UserDefaults.standard
        let bridgeAccessConfigJSON = bridgeAccessConfig.toJSON()
        userDefaults.set(bridgeAccessConfigJSON, forKey: bridgeAccessConfigUserDefaultsKey)
    }
}

// MARK: CreateBridgeAccessControllerDelegate

extension ViewController: CreateBridgeAccessControllerDelegate {
    
    func bridgeAccessCreated(bridgeAccessConfig: BridgeAccessConfig) {
        
        writeBridgeAccessConfig(bridgeAccessConfig: bridgeAccessConfig)
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
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.lightChanged), name: NSNotification.Name(rawValue: ResourceCacheUpdateNotification.lightsUpdated.rawValue), object: nil)
        
        //        var lightState = LightState()
        //        lightState.on = true
        
        //        BridgeSendAPI.updateLightStateForId("324325675tzgztztut1234434334", withLightState: lightState) { (errors) in
        //            print(errors)
        //        }
        
        //        BridgeSendAPI.setLightStateForGroupWithId("huuuuuuu1", withLightState: lightState) { (errors) in
        //
        //            print(errors)
        //        }
        
        //        BridgeSendAPI.createGroupWithName("TestRoom", andType: GroupType.LightGroup, includeLightIds: ["1","2"]) { (errors) in
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
        
        //        BridgeSendAPI.createSceneWithName("MeineTestScene", includeLightIds: ["1"]) { (errors) in
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
    
    @objc public func lightChanged() {
        
        print("Changed")
        
//        var cache = BridgeResourcesCacheManager.sharedInstance.cache
//        var light = cache.groups["1"]!
//        print(light.name)
    }
    
    // MARK: - BridgeFinderDelegate
    
    func bridgeFinder(_ finder: BridgeFinder, didFinishWithResult bridges: [HueBridge]) {
        print(bridges)
        guard let bridge = bridges.first else {
            return
        }
        
        bridgeAuthenticator = BridgeAuthenticator(bridge: bridge, uniqueIdentifier: "example#simulator")
        bridgeAuthenticator!.delegate = self
        bridgeAuthenticator!.start()
    }
    
    // MARK: - BridgeAuthenticatorDelegate
    
    func bridgeAuthenticatorDidTimeout(_ authenticator: BridgeAuthenticator) {
        print("Timeout")
    }
    
    func bridgeAuthenticator(_ authenticator: BridgeAuthenticator, didFailWithError error: NSError) {
        print("Error while authenticating: \(error)")
    }
    
    func bridgeAuthenticatorRequiresLinkButtonPress(_ authenticator: BridgeAuthenticator, secondsLeft: TimeInterval) {
        print("Press link button")
    }
    
    func bridgeAuthenticator(_ authenticator: BridgeAuthenticator, didFinishAuthentication username: String) {
        print("Authenticated, hello \(username)")
    }
}

