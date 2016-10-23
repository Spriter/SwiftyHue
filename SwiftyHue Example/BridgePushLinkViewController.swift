//
//  BridgePushLinkViewController.swift
//  SwiftyHue
//
//  Created by Marcel Dittmann on 08.05.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SwiftyHue

class BridgePushLinkViewController: UIViewController {

    var bridge: HueBridge!;
    var bridgeAuthenticator: BridgeAuthenticator!
    var bridgeAccessConfig: BridgeAccessConfig!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bridgeAuthenticator = BridgeAuthenticator(bridge: bridge, uniqueIdentifier: "swiftyhue#\(UIDevice.current.name)")
        bridgeAuthenticator.delegate = self;
        bridgeAuthenticator.start()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destController = segue.destination as! BridgeAccessConfigPresentationViewController;
        destController.bridgeAccesssConfig = bridgeAccessConfig;
    }

}

extension BridgePushLinkViewController: BridgeAuthenticatorDelegate {
    
    func bridgeAuthenticator(_ authenticator: BridgeAuthenticator, didFinishAuthentication username: String) {
        
        self.bridgeAccessConfig = BridgeAccessConfig(bridgeId: "BridgeId", ipAddress: bridge.ip, username: username)
        
        self.performSegue(withIdentifier: "BridgeAccessConfigPresentationViewControllerSegue", sender: self)
    }
    
    func bridgeAuthenticator(_ authenticator: BridgeAuthenticator, didFailWithError error: NSError) {
     
        print(error)
    }
    
    // you should now ask the user to press the link button
    func bridgeAuthenticatorRequiresLinkButtonPress(_ authenticator: BridgeAuthenticator) {

    }
    // user did not press the link button in time, you restart the process and try again
    func bridgeAuthenticatorDidTimeout(_ authenticator: BridgeAuthenticator) {
        
        print("timeout")
    }
}
