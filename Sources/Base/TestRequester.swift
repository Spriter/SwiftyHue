//
//  TestRequester.swift
//  Pods
//
//  Created by Marcel Dittmann on 21.04.16.
//
//

import Foundation
import Alamofire
import Gloss

public class TestRequester {
    
    private var bridgeAcc = "hkoPdsoXKRVsbI6wcPWdcu4ud0jnIEhfoP4GftxY";
    private var bridgeIp = "192.168.0.10"
    //private var bridgeAcc = "52a1a8b66269b2c737449fd64e91f19c";
    //private var bridgeIp = "192.168.1.2"
    
    public static var sharedInstance = TestRequester()
    
    public init() {
        
    }

//    public func getConfig() {
//        
//        Alamofire.request("http://\(bridgeIp)/api/\(bridgeAcc)/config", parameters: nil)
//            .responseJSON { response in
//                
//                if let resultValueJSON = response.result.value as? NSMutableDictionary {
//                    
//                    //print("JSON: \(JSON as! NSMutableDictionary)")
//                    
//                    // Create Native Objects
//                    var groups = [Scene]();
//                    
//                    let config = BridgeConfiguration(json: resultValueJSON as! JSON)!
//                    print(config.localtime)
//                    
//                }
//        }
//        
//    }

    
    
    public func test() {
    
        var lightState = LightState();
        lightState.on = false;
    
        let parameters = lightState.toJSON()!
        let url = "http://\(bridgeIp)/api/\(bridgeAcc)/groups/1/action"

        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
        
                print(response)
        }
    }

//    public func requestScene() {
//        Alamofire.request("http://\(bridgeIp)/api/\(bridgeAcc)/scenes/y3Npr8e3za8okWb", parameters: nil)
//            .responseJSON { response in
//                
//                if let resultValueJSON = response.result.value as? NSMutableDictionary {
//                    
//                    //print("JSON: \(JSON as! NSMutableDictionary)")
//
//                    // Create Native Objects
//                    var groups = [Scene]();
//
//                    groups.append(Scene(json: resultValueJSON as! JSON)!)
//                
//                    for scene in groups {
//                        
////                        print(scene.name)
////                        print(scene.identifier)
////                        print(scene.lightstates![0].on)
//                    }
//                }
//        }
//    }
    
//    public func requestScenes() {
//        Alamofire.request("http://\(bridgeIp)/api/\(bridgeAcc)/scenes", parameters: nil)
//            .responseJSON { response in
//                
//                if let resultValueJSON = response.result.value as? NSMutableDictionary {
//                    
//                    //print("JSON: \(JSON as! NSMutableDictionary)")
//                    
//                    var groupJSONs = TestRequester.convert(resultValueJSON)
//                    print(groupJSONs)
//                    // Create Native Objects
//                    var groups = [PartialScene]();
//                    for item in groupJSONs {
//                        
//                        groups.append(PartialScene(json: item)!)
//                    }
//                    
//                    for scene in groups {
//                        
//                        //print("\(scene.name) id: \(scene.identifier)")
//                    }
//                }
//        }
//    }

//    public func requestGroups() {
//        Alamofire.request("http://\(bridgeIp)/api/\(bridgeAcc)/groups", parameters: nil)
//            .responseJSON { response in
//                
//                if let resultValueJSON = response.result.value as? NSMutableDictionary {
//                    
//                    //print("JSON: \(JSON as! NSMutableDictionary)")
//                    
//                    var groupJSONs = TestRequester.convert(resultValueJSON)
//                    
//                    // Create Native Objects
//                    var groups = [Group]();
//                    for item in groupJSONs {
//                        
//                        groups.append(Group(json: item)!)
//                    }
//                    
//                    for group in groups {
//                        
//                        print(group.type == GroupType.Room)
//                    }
//                }
//        }
//    }
    
    public func requestGroups() {
        Alamofire.request("http://\(bridgeIp)/api/\(bridgeAcc)/groups", parameters: nil)
        .responseJSON { response in
            
            if let resultValueJSON = response.result.value as? JSON {

                let groupsDict = Group.dictionaryFromResourcesJSON(resultValueJSON)
            
                for group in groupsDict {
                    
                    print("\(group.0) \(group.1.name)")
                }
            }
        }
    }
    
    public func requestScenes() {
        Alamofire.request("http://\(bridgeIp)/api/\(bridgeAcc)/scenes", parameters: nil)
            .responseJSON { response in
                
                if let resultValueJSON = response.result.value as? JSON {
                    
                    let scenesDict = PartialScene.dictionaryFromResourcesJSON(resultValueJSON)
                    print(scenesDict)
                    for scene in scenesDict {
                        
                        print("\(scene.0) \(scene.1.name)")
                    }
                }
        }
    }
    
    public func requestRules() {
        Alamofire.request("http://\(bridgeIp)/api/\(bridgeAcc)/rules", parameters: nil)
            .responseJSON { response in
                
                if let resultValueJSON = response.result.value as? JSON {
                    
                    let rulesDict = Rule.dictionaryFromResourcesJSON(resultValueJSON)
                    print(rulesDict)
                    for rule in rulesDict {
                        
                        print("\(rule.0) \(rule.1.name)")
                    }
                }
        }
    }
    
//    public func requestSensors() {
//        Alamofire.request("http://\(bridgeIp)/api/\(bridgeAcc)/sensors", parameters: nil)
//            .responseJSON { response in
//                
//                if let resultValueJSON = response.result.value as? JSON {
//                    
//                    let sensorDict = Sensor.dictionaryFromResourcesJSON(resultValueJSON)
//                    print(sensorDict)
//                    for rule in sensorDict {
//                        
//                        print("\(rule.0) \(rule.1.name)")
//                    }
//                }
//        }
//    }
    
    public func requestSchedules() {
        Alamofire.request("http://\(bridgeIp)/api/\(bridgeAcc)/schedules", parameters: nil)
            .responseJSON { response in
                
                if let resultValueJSON = response.result.value as? JSON {
                    
                    let schedulesDict = Schedule.dictionaryFromResourcesJSON(resultValueJSON)
                    print(schedulesDict)
                    for schedule in schedulesDict {
                        
                        print("\(schedule.0) \(schedule.1.name)")
                    }
                }
        }
    }
    
    public func requestBridgeConfiguration() {
        
        Alamofire.request("http://\(bridgeIp)/api/\(bridgeAcc)/config", parameters: nil)
            .responseJSON { response in
                
                if let resultValueJSON = response.result.value as? JSON {
                    
                    let groupsDict = BridgeConfiguration(json: resultValueJSON)
                    print(groupsDict?.toJSON() as Any)
                }
        }
    }
    
    public func requestLights() {
        Alamofire.request("http://\(bridgeIp)/api/\(bridgeAcc)/lights", parameters: nil)
            .responseJSON { response in
                
            if let resultValueJSON = response.result.value as? JSON {
                
                let lightsDict = Light.dictionaryFromResourcesJSON(resultValueJSON)
                print(lightsDict)
            }
        }
    }
    
    public func requestError() {
        Alamofire.request("http://\(bridgeIp)/api/\(bridgeAcc)/giveMeAError", parameters: nil)
            .responseJSON { response in
                
                if let resultValueJSON = response.result.value as? [JSON] {
                    
                    let errors = [HueError].from(jsonArray: resultValueJSON)
                    print(errors ?? "(no errors)")
                }
        }
    }
    
    class func convert(_ resourcesDict: NSMutableDictionary) -> [JSON] {
        
        var resourceJSONs = [[String: Any]]();
        
        for item in resourcesDict {
            var resourceJSON = item.value as! [String: Any];
            resourceJSON["id"] = item.key;
            
            resourceJSONs.append(resourceJSON)
        }
        
        return resourceJSONs

    }
    
}
