//
//  BridgeResourceTableViewController.swift
//  SwiftyHue
//
//  Created by Marcel Dittmann on 09.05.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SwiftyHue

class BridgeResourceTableViewController: UITableViewController {

    var resourceTypeToDisplay: HeartbeatBridgeResourceType = .lights
    var bridgeResources =  [BridgeResource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateResources()
    }
    
    func updateResources() {
        
        if let resourceCache = swiftyHue.resourceCache {
            
            switch resourceTypeToDisplay {
                
            case .lights:
              
                for light in resourceCache.lights.values {
                    bridgeResources.append(light)
                }
                
            case .groups:
                
                for group in resourceCache.groups.values {
                    bridgeResources.append(group)
                }
                
            case .scenes:
                
                for scene in resourceCache.scenes.values {
                    bridgeResources.append(scene)
                }
                
            case .rules:
                
                for rule in resourceCache.rules.values {
                    bridgeResources.append(rule)
                }
                
            case .schedules:
                
                for schedule in resourceCache.schedules.values {
                    bridgeResources.append(schedule)
                }
                
            case .sensors:
                
                for sensor in resourceCache.sensors.values {
                    bridgeResources.append(sensor)
                }
                
            case .config:
                
                if let config = resourceCache.bridgeConfiguration {
                    bridgeResources.append(config)
                }
            
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bridgeResources.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BridgeResourceTableViewCell", forIndexPath: indexPath)

        let bridgeResource = self.bridgeResources[indexPath.row]
        
        cell.textLabel?.text = bridgeResource.name
        
        return cell
    }
}
