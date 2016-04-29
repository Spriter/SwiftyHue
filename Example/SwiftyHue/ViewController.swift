//
//  ViewController.swift
//  SwiftyHue
//
//  Created by Marcel Dittmann on 04/21/2016.
//  Copyright (c) 2016 Marcel Dittmann. All rights reserved.
//

import UIKit
import SwiftyHue

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var beatManager = BeatManager()
        beatManager.setLocalHeartbeatInterval(3, forResourceType: .Lights)
        beatManager.setLocalHeartbeatInterval(3, forResourceType: .Groups)
        beatManager.startHeartbeat()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.lightChanged), name: HeartbeatNotification.GroupsUpdated.rawValue, object: nil)
        
        var lightState = LightState()
        lightState.on = true

        BridgeSendAPI.updateLightStateForId("324325675tzgztztut1234434334", withLightState: lightState) { (errors) in
            print(errors)
        }
        
//        BridgeSendAPI.setLightStateForGroupWithId("huuuuuuu1", withLightState: lightState) { (errors) in
//            
//            print(errors)
//        }
        
        //TestRequester.sharedInstance.requestLights()
        //TestRequester.sharedInstance.getConfig()
        //TestRequester.sharedInstance.requestError()
        
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

}

