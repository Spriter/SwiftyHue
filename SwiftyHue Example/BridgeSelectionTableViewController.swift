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
        
        self.setBackgroundMessage(message: "Searching Bridge")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bridgeFinder.delegate = self;
        bridgeFinder.start()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bridges?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let bridge = self.bridges![indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BridgeCell", for: indexPath)
        cell.textLabel?.text = bridge.friendlyName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedBridge = bridges![indexPath.row]
 
        performSegue(withIdentifier: "BridgePushLinkViewControllerSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destController = segue.destination as! BridgePushLinkViewController;
        destController.bridge = selectedBridge
    }
}

extension BridgeSelectionTableViewController: BridgeFinderDelegate {
    
    func bridgeFinder(_ finder: BridgeFinder, didFinishWithResult bridges: [HueBridge]) {
     
        self.bridges = bridges;
        self.setBackgroundMessage(message: nil)
        self.tableView.reloadData()
    }
}
