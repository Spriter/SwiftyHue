//
//  ViewController.swift
//  SwiftyHue
//
//  Created by Marcel Dittmann on 04/21/2016.
//  Copyright (c) 2016 Marcel Dittmann. All rights reserved.
//

import UIKit
import SwiftyHue

class ViewController: UIViewController, BridgeFinderDelegate, BridgeAuthenticatorDelegate {
    private let bridgeFinder = BridgeFinder()
    private var bridgeAuthenticator: BridgeAuthenticator?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bridgeFinder.delegate = self
        bridgeFinder.start()

        var beatManager = BeatManager()
        beatManager.setLocalHeartbeatInterval(3, forResourceType: .Lights)
        beatManager.setLocalHeartbeatInterval(3, forResourceType: .Groups)
        beatManager.startHeartbeat()
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.lightChanged), name: HeartbeatNotification.GroupsUpdated.rawValue, object: nil)
        
        var lightState = LightState()
        lightState.on = true

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
        
        TestRequester.sharedInstance.requestSchedules()
        
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
        
        BridgeSendAPI.recallSceneWithIdentifier("14530729836055", inGroupWithIdentifier: "2") { (errors) in
            
            print(errors)
        }
    }
    
    public func lightChanged() {
        
        var cache = BridgeResourcesCacheManager.sharedInstance.cache
        var light = cache.groups["1"]!
        print(light.name)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

