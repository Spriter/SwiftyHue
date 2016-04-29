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
    
    public static var sharedInstance = TestRequester()
    
    public init() {
        
    }

//    public func getConfig() {
//        
//        Alamofire.request(.GET, "http://\(bridgeIp)/api/\(bridgeAcc)/config", parameters: nil)
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
        
        Alamofire.request(.PUT, "http://\(bridgeIp)/api/\(bridgeAcc)/groups/1/action", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
        
                print(response)
        }
    }

//    public func requestScene() {
//        Alamofire.request(.GET, "http://\(bridgeIp)/api/\(bridgeAcc)/scenes/y3Npr8e3za8okWb", parameters: nil)
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
//        Alamofire.request(.GET, "http://\(bridgeIp)/api/\(bridgeAcc)/scenes", parameters: nil)
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
//        Alamofire.request(.GET, "http://\(bridgeIp)/api/\(bridgeAcc)/groups", parameters: nil)
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
        Alamofire.request(.GET, "http://\(bridgeIp)/api/\(bridgeAcc)/groups", parameters: nil)
        .responseJSON { response in
            
            if let resultValueJSON = response.result.value as? JSON {

                let groupsDict = Group.dictionaryFromResourcesJSON(resultValueJSON)
                print(groupsDict)
            }
        }
    }
    
    public func requestScenes() {
        Alamofire.request(.GET, "http://\(bridgeIp)/api/\(bridgeAcc)/scenes", parameters: nil)
            .responseJSON { response in
                
            if let resultValueJSON = response.result.value as? JSON {
                
                let groupsDict = PartialScene.dictionaryFromResourcesJSON(resultValueJSON)
                print(groupsDict)
            }
        }
    }
    
    public func requestBridgeConfiguration() {
        
        Alamofire.request(.GET, "http://\(bridgeIp)/api/\(bridgeAcc)/config", parameters: nil)
            .responseJSON { response in
                
                if let resultValueJSON = response.result.value as? JSON {
                    
                    let groupsDict = BridgeConfiguration(json: resultValueJSON)
                    print(groupsDict?.toJSON())
                }
        }
    }
    
    public func requestLights() {
        Alamofire.request(.GET, "http://\(bridgeIp)/api/\(bridgeAcc)/lights", parameters: nil)
            .responseJSON { response in
                
            if let resultValueJSON = response.result.value as? JSON {
                
                let lightsDict = Light.dictionaryFromResourcesJSON(resultValueJSON)
                print(lightsDict)
            }
        }
    }
    
    class func convert(resourcesDict: NSMutableDictionary) -> [JSON] {
        
        if let JSON = resourcesDict as? NSMutableDictionary {
            
            var resourceJSONs = [[String: AnyObject]]();
            
            for item in JSON {
                
                var resourceJSON = item.value as! [String: AnyObject];
                resourceJSON["id"] = item.key;
                
                resourceJSONs.append(resourceJSON)
            }
            
            return resourceJSONs
            
        }
        
    }
    
}