//
//  BridgeSelectionTableViewController.swift
//  SwiftyHue
//
//  Created by Marcel Dittmann on 08.05.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SwiftyHue

class BridgeSelectionTableViewController: UITableViewController {

    var bridgeFinder = BridgeFinder()
    var bridges: [HueBridge]?;
    var selectedBridge: HueBridge?
    
    override func viewDidLoad() {
        
        self.setBackgroundMessage("Searching Bridge")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        bridgeFinder.delegate = self;
        bridgeFinder.start()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bridges?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let bridge = self.bridges![indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BridgeCell", forIndexPath: indexPath)
        cell.textLabel?.text = bridge.friendlyName
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedBridge = bridges![indexPath.row]
 
        self.performSegueWithIdentifier("BridgePushLinkViewControllerSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destController = segue.destinationViewController as! BridgePushLinkViewController;
        destController.bridge = selectedBridge
    }
}

extension BridgeSelectionTableViewController: BridgeFinderDelegate {
    
    func bridgeFinder(finder: BridgeFinder, didFinishWithResult bridges: [HueBridge]) {
     
        self.bridges = bridges;
        self.setBackgroundMessage(nil)
        self.tableView.reloadData()
    }
}
