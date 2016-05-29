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

    var resourceTypeToDisplay: BridgeResourceType = .Lights
    var bridgeResources =  [BridgeResource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateResources()
    }
    
    func updateResources() {
        
        if let resourceCache = swiftyHue.resourceCache {
            
            switch resourceTypeToDisplay {
                
            case .Lights:
              
                for light in resourceCache.lights.values {
                    bridgeResources.append(light)
                }
                
            case .Groups:
                
                for group in resourceCache.groups.values {
                    bridgeResources.append(group)
                }
                
            case .Scenes:
                
                for scene in resourceCache.scenes.values {
                    bridgeResources.append(scene)
                }
                
            case .Rules:
                
                for rule in resourceCache.rules.values {
                    bridgeResources.append(rule)
                }
                
            case .Schedules:
                
                for schedule in resourceCache.schedules.values {
                    bridgeResources.append(schedule)
                }
                
            case .Sensors:
                
                for sensor in resourceCache.sensors.values {
                    bridgeResources.append(sensor)
                }
                
            case .Config:
                
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
