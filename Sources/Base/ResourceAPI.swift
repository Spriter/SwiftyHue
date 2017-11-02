//
//  ResourceAPI.swift
//  SwiftyHue
//
//  Created by Marcel Dittmann on 02.11.17.
//

import Foundation

import Foundation
import Alamofire
import Gloss

public class ResourceAPI {
    
    private var bridgeAccessConfig: BridgeAccessConfig?;
    
    func setBridgeAccessConfig(_ bridgeAccessConfig: BridgeAccessConfig) {
        
        self.bridgeAccessConfig = bridgeAccessConfig
    }
    
    public func fetch<Resource: BridgeResourceDictGenerator>(resource: HeartbeatBridgeResourceType, completionHandler:@escaping (Alamofire.Result<[String: Resource]>) -> ()) where Resource.AssociatedBridgeResourceType == Resource {
        
        guard let bridgeAccessConfig = bridgeAccessConfig else {
            
            completionHandler(Alamofire.Result.failure(HueError(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!))
            return
        }
        
        let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/\(resource.rawValue.lowercased())"
        
        Alamofire.request(url).responseJSON { response in
            
            switch response.result {
                
            case .success(let data):
                
                let resources = Resource.dictionaryFromResourcesJSON(data as! JSON)
                completionHandler(.success(resources))
                
            case .failure(let error):
                
                completionHandler(.failure(error))
            }
        }
    }
    
    public func fetchLights(_ completionHandler: @escaping (Alamofire.Result<[String: Light]>) -> ()) {
        fetch(resource: .lights, completionHandler: completionHandler)
    }
    
    public func fetchGroups(_ completionHandler: @escaping (Alamofire.Result<[String: Group]>) -> ()) {
        fetch(resource: .groups, completionHandler: completionHandler)
    }
    
    public func fetchScenes(_ completionHandler: @escaping (Alamofire.Result<[String: PartialScene]>) -> ()) {
        fetch(resource: .scenes, completionHandler: completionHandler)
    }
    
    public func fetchRules(_ completionHandler: @escaping (Alamofire.Result<[String: Rule]>) -> ()) {
        fetch(resource: .rules, completionHandler: completionHandler)
    }
    
    public func fetchSensors(_ completionHandler: @escaping (Alamofire.Result<[String: Sensor]>) -> ()) {
        fetch(resource: .sensors, completionHandler: completionHandler)
    }
    
    public func fetchSchedules(_ completionHandler: @escaping (Alamofire.Result<[String: Schedule]>) -> ()) {
        fetch(resource: .schedules, completionHandler: completionHandler)
    }
}
