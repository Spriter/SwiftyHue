//
//  ResourceAPI.swift
//  SwiftyHue
//
//  Created by Marcel Dittmann on 02.11.17.
//

import Foundation

import Foundation
import Alamofire

public class ResourceAPI {
    
    private var bridgeAccessConfig: BridgeAccessConfig?;
    
    func setBridgeAccessConfig(_ bridgeAccessConfig: BridgeAccessConfig) {
        
        self.bridgeAccessConfig = bridgeAccessConfig
    }
    
    public func fetch<Resource: BridgeResourceDictGenerator>(resource: HeartbeatBridgeResourceType, completionHandler:@escaping (Result<[String: Resource], Error>) -> ()) where Resource.AssociatedBridgeResourceType == Resource {
        
        guard let bridgeAccessConfig = bridgeAccessConfig else {
            
            completionHandler(.failure(HueError(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!))
            return
        }
        
        let url = "https://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/\(resource.rawValue.lowercased())"
        
        HueNetwork.session.request(url).responseJSON { response in
            
            switch response.result {
                
            case .success(let data) where data is JSON:
                
                let resources = Resource.dictionaryFromResourcesJSON(data as! JSON)
                completionHandler(.success(resources))
                
            case .success(_):
                completionHandler(.failure(NSError(domain: "unexpected response", code: 0, userInfo: nil)))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func fetchLights(_ completionHandler: @escaping (Result<[String: Light], Error>) -> ()) {
        fetch(resource: .lights, completionHandler: completionHandler)
    }
    
    public func fetchGroups(_ completionHandler: @escaping (Result<[String: Group], Error>) -> ()) {
        fetch(resource: .groups, completionHandler: completionHandler)
    }
    
    public func fetchScenes(_ completionHandler: @escaping (Result<[String: PartialScene], Error>) -> ()) {
        fetch(resource: .scenes, completionHandler: completionHandler)
    }
    
    public func fetchRules(_ completionHandler: @escaping (Result<[String: Rule], Error>) -> ()) {
        fetch(resource: .rules, completionHandler: completionHandler)
    }
    
    public func fetchSensors(_ completionHandler: @escaping (Result<[String: Sensor], Error>) -> ()) {
        fetch(resource: .sensors, completionHandler: completionHandler)
    }
    
    public func fetchSchedules(_ completionHandler: @escaping (Result<[String: Schedule], Error>) -> ()) {
        fetch(resource: .schedules, completionHandler: completionHandler)
    }
}
