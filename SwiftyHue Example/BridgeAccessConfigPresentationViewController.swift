//
//  BridgeAccessConfigPresentationViewController.swift
//  SwiftyHue
//
//  Created by Marcel Dittmann on 08.05.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SwiftyHue

class BridgeAccessConfigPresentationViewController: UIViewController {

    var bridgeAccesssConfig: BridgeAccessConfig!
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var bridgeIdLabel: UILabel!
    @IBOutlet var ipLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        usernameLabel?.text = bridgeAccesssConfig.username
        bridgeIdLabel?.text = bridgeAccesssConfig.bridgeId
        ipLabel?.text = bridgeAccesssConfig.ipAddress
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okButtonTapped(sender: AnyObject) {
    
        (navigationController as! CreateBridgeAccessController).bridgeAccessCreated(bridgeAccesssConfig)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
