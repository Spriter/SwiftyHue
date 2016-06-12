//
//  BridgeSendAPI.swift
//  Pods
//
//  Created by Marcel Dittmann on 29.04.16.
//
//

import Foundation
import Alamofire
import Gloss

public class BridgeSendAPI {
  
    //    public typealias PHBridgeSendDictionaryCompletionHandler = (dictionary: [String: AnyObject], errors: [Error]?) -> Void
    public typealias BridgeSendErrorArrayCompletionHandler = (errors: [Error]?) -> Void
    
    private var bridgeAccessConfig: BridgeAccessConfig?;
    
    init() {
        
    }
    
    func setBridgeAccessConfig(bridgeAccessConfig: BridgeAccessConfig) {
        
        self.bridgeAccessConfig = bridgeAccessConfig
    }
    
    // MARK: Scenes
    
    public func recallSceneWithIdentifier(identifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        let parameters = ["scene": identifier]
        
        if let bridgeAccessConfig = bridgeAccessConfig {
         
            Alamofire.request(.PUT, "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups/0/action", parameters: parameters, encoding: .JSON)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    public func recallSceneWithIdentifier(identifier: String, inGroupWithIdentifier groupIdentifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = bridgeAccessConfig {
            
            let parameters = ["scene": identifier]
            
            Alamofire.request(.PUT, "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups/\(groupIdentifier)/action", parameters: parameters, encoding: .JSON)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    /**
     Creates the given scene with all lights in the provided lights resource. For a given scene the current light settings of the given lights resources are stored. If the scene id is recalled in the future, these light settings will be reproduced on these lamps. If an existing name is used then the settings for this scene will be overwritten and the light states resaved. The bridge can support up to 200 scenes, however please also note there is a maximum of 2048 scene lightstates so for example, of all your scenes have 20 lightstates, the maximum number of allowed scenes will be 102.
     */
    public func createSceneWithName(name: String, inlcudeLightIds lightIds: [String], recycle: Bool = false, transitionTime: Int? = nil, picture: String? = nil, appData: AppData? = nil, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = bridgeAccessConfig {
            
            var parameters: [String: AnyObject] = ["name": name, "lights": lightIds, "recycle": recycle];
            
            parameters["transitiontime"] = transitionTime
            parameters["picture"] = picture
            parameters["appdata"] = appData?.toJSON()
            
            Alamofire.request(.POST, "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/scenes", parameters: parameters, encoding: .JSON)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    public func removeSceneWithId(identifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        remove(.scene, withIdentifier: identifier, completionHandler: completionHandler)
    }
    
    // MARK: Lights
    
    public func updateLightStateForId(identifier: String, withLightState lightState: LightState, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = bridgeAccessConfig {
            
            let parameters = lightState.toJSON()!
            
            Alamofire.request(.PUT, "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/lights/\(identifier)/state", parameters: parameters, encoding: .JSON)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    public func removeLightWithId(identifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        remove(.light, withIdentifier: identifier, completionHandler: completionHandler)
    }
    
    // MARK: Groups
    
    public func createRoomWithName(name: String, andType type: GroupType, andRoomClass roomClass: RoomClass, inlcudeLightIds lightIds: [String], completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = self.bridgeAccessConfig {
            
            let parameters: [String: AnyObject] = ["name": name, "class": roomClass.rawValue, "type": type.rawValue
                , "lights": lightIds]
            
            Alamofire.request(.POST, "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups", parameters: parameters, encoding: .JSON)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    public func createGroupWithName(name: String, andType type: GroupType, inlcudeLightIds lightIds: [String], completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = self.bridgeAccessConfig {
            
            let parameters: [String: AnyObject] = ["name": name, "type": type.rawValue
                , "lights": lightIds]
            
            Alamofire.request(.POST, "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups", parameters: parameters, encoding: .JSON)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    /** 
     Allows the user to modify the name and the lights of a group
    */
    public func updateGroupWithId(identifier: String, newName: String?, newLightIdentifiers: [String]?, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = self.bridgeAccessConfig {
            
            var parameters = [String: AnyObject]()
            
            parameters["name"] = newName;
            parameters["lights"] = newLightIdentifiers;
            
            Alamofire.request(.PUT, "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups/\(identifier)", parameters: parameters, encoding: .JSON)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    /**
     Allows the user to modify the name and the lights of a group
     */
    public func updateRoomWithId(identifier: String, newName: String?, newLightIdentifiers: [String]?, newRoomClass: RoomClass?, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = self.bridgeAccessConfig {
            
            var parameters = [String: AnyObject]()
            
            parameters["name"] = newName;
            parameters["class"] = newRoomClass?.rawValue;
            parameters["lights"] = newLightIdentifiers;
            
            Alamofire.request(.PUT, "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups/\(identifier)", parameters: parameters, encoding: .JSON)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    public func removeGroupWithId(identifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        remove(.group, withIdentifier: identifier, completionHandler: completionHandler)
    }
    
    public func setLightStateForGroupWithId(identifier: String, withLightState lightState: LightState, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        let parameters = lightState.toJSON()!
        
        if let bridgeAccessConfig = self.bridgeAccessConfig {
            
            Alamofire.request(.PUT, "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups/\(identifier)/action", parameters: parameters, encoding: .JSON)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    // MARK: Rules
    
    public func createRuleWithName(name: String, andConditions conditions: [RuleCondition], andActions actions: [RuleAction], completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = self.bridgeAccessConfig {
            
            var parameters = [String: AnyObject]()
            
            parameters["name"] = name;
            parameters["conditions"] = conditions.toJSONArray();
            parameters["actions"] = actions.toJSONArray();
            
            Alamofire.request(.POST, "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/rules", parameters: parameters, encoding: .JSON)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    public func updateRuleWithId(identifier: String, newName: String, newConditions: [RuleCondition]?, newActions: [RuleAction]?, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = self.bridgeAccessConfig {
            
            var parameters = [String: AnyObject]()
            
            parameters["name"] = newName;
            parameters["conditions"] = newConditions?.toJSONArray();
            parameters["actions"] = newActions?.toJSONArray();
            
            Alamofire.request(.PUT, "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/rules/\(identifier)", parameters: parameters, encoding: .JSON)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    public func removeRuleWithId(identifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        remove(.rule, withIdentifier: identifier, completionHandler: completionHandler)
    }
    
    // MARK: Schedules
    
    public func createScheduleWithName(name: String, andCommand command: ScheduleCommand, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = self.bridgeAccessConfig {
            
            var parameters = [String: AnyObject]()
            
            parameters["name"] = name;
            parameters["command"] = command.toJSON();
            
            Alamofire.request(.POST, "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/schedules", parameters: parameters, encoding: .JSON)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    public func updateScheduleWithId(identifier: String, newName: String, newCommand: ScheduleCommand, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = self.bridgeAccessConfig {
            
            var parameters = [String: AnyObject]()
            
            parameters["name"] = newName;
            parameters["command"] = newCommand.toJSON();
            
            Alamofire.request(.PUT, "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/schedules/\(identifier)", parameters: parameters, encoding: .JSON)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    public func removeScheduleWithId(identifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        remove(.schedule, withIdentifier: identifier, completionHandler: completionHandler)
    }
    
    // MARK: Sensors
    
    public func removeSensorWithId(identifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        remove(.sensor, withIdentifier: identifier, completionHandler: completionHandler)
    }
    
    // MARK: Whitelist Entry
    
    public func removeWhitelistEntryWithId(identifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        remove(.whitelistEntry, withIdentifier: identifier, completionHandler: completionHandler)
    }

    // MARK: Helpers
    
    private func errorsFromResponse(response: Response<AnyObject, NSError>) -> [Error]? {
        
        var errors: [Error]?
        if let responseItemJSONs = response.result.value as? [JSON] {
            
            errors = [Error].fromJSONArray(responseItemJSONs)
        }
        
        return errors?.count > 0 ? errors : nil
    }
    
    private func remove(bridgeResourceType: BridgeResourceType, withIdentifier identifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        let resourceTypeForURL = bridgeResourceType == .whitelistEntry
                                 ? "config/whitelist"
                                 : "\(bridgeResourceType)s"
        
        if let bridgeAccessConfig = self.bridgeAccessConfig {
            
            Alamofire.request(.DELETE, "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/\(resourceTypeForURL)/\(identifier)", encoding: .JSON)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
}