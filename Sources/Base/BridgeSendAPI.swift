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
    
    func setBridgeAccessConfig(_ bridgeAccessConfig: BridgeAccessConfig) {
        
        self.bridgeAccessConfig = bridgeAccessConfig
    }
    
    // MARK: Scenes
    
    public func recallSceneWithIdentifier(_ identifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        let parameters = ["scene": identifier]
        
        if let bridgeAccessConfig = bridgeAccessConfig {

            let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups/0/action"

            Alamofire.request(.PUT, url, parameters: parameters, encoding: .json)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    public func recallSceneWithIdentifier(_ identifier: String, inGroupWithIdentifier groupIdentifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = bridgeAccessConfig {
            
            let parameters = ["scene": identifier]
            let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups/\(groupIdentifier)/action"

            Alamofire.request(.PUT, url, parameters: parameters, encoding: .json)
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
    public func createSceneWithName(_ name: String, inlcudeLightIds lightIds: [String], recycle: Bool = false, transitionTime: Int? = nil, picture: String? = nil, appData: AppData? = nil, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = bridgeAccessConfig {
            
            var parameters: [String: AnyObject] = ["name": name, "lights": lightIds, "recycle": recycle];
            let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/scenes"

            parameters["transitiontime"] = transitionTime
            parameters["picture"] = picture
            parameters["appdata"] = appData?.toJSON()

            Alamofire.request(.POST, url, parameters: parameters, encoding: .json)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    public func removeSceneWithId(_ identifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        remove(.scene, withIdentifier: identifier, completionHandler: completionHandler)
    }
    
    // MARK: Lights
    
    public func updateLightStateForId(_ identifier: String, withLightState lightState: LightState, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = bridgeAccessConfig {
            
            let parameters = lightState.toJSON()!
            let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/lights/\(identifier)/state"

            Alamofire.request(.PUT, url, parameters: parameters, encoding: .json)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    public func removeLightWithId(_ identifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        remove(.light, withIdentifier: identifier, completionHandler: completionHandler)
    }
    
    // MARK: Groups
    
    public func createRoomWithName(_ name: String, andType type: GroupType, andRoomClass roomClass: RoomClass, inlcudeLightIds lightIds: [String], completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = self.bridgeAccessConfig {
            
            let parameters: [String: AnyObject] = ["name": name, "class": roomClass.rawValue, "type": type.rawValue
                , "lights": lightIds]
            let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups"
            
            Alamofire.request(.POST, url, parameters: parameters, encoding: .json)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    public func createGroupWithName(_ name: String, andType type: GroupType, inlcudeLightIds lightIds: [String], completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = self.bridgeAccessConfig {
            
            let parameters: [String: AnyObject] = ["name": name, "type": type.rawValue
                , "lights": lightIds]
            let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups"

            Alamofire.request(.POST, url, parameters: parameters, encoding: .json)
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
    public func updateGroupWithId(_ identifier: String, newName: String?, newLightIdentifiers: [String]?, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = self.bridgeAccessConfig {
            
            var parameters = [String: AnyObject]()
            let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups/\(identifier)"
            parameters["name"] = newName;
            parameters["lights"] = newLightIdentifiers;
            
            Alamofire.request(.PUT, url, parameters: parameters, encoding: .json)
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
    public func updateRoomWithId(_ identifier: String, newName: String?, newLightIdentifiers: [String]?, newRoomClass: RoomClass?, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = self.bridgeAccessConfig {
            
            var parameters = [String: AnyObject]()
            let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups/\(identifier)"

            parameters["name"] = newName;
            parameters["class"] = newRoomClass?.rawValue;
            parameters["lights"] = newLightIdentifiers;
            
            Alamofire.request(.PUT, url, parameters: parameters, encoding: .json)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    public func removeGroupWithId(_ identifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        remove(.group, withIdentifier: identifier, completionHandler: completionHandler)
    }
    
    public func setLightStateForGroupWithId(_ identifier: String, withLightState lightState: LightState, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = self.bridgeAccessConfig {

            let parameters = lightState.toJSON()!
            let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups/\(identifier)/action"
            
            Alamofire.request(.PUT, url, parameters: parameters, encoding: .json)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    // MARK: Rules
    
    public func createRuleWithName(_ name: String, andConditions conditions: [RuleCondition], andActions actions: [RuleAction], completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = self.bridgeAccessConfig {
            
            var parameters = [String: AnyObject]()
            let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/rules"

            parameters["name"] = name;
            parameters["conditions"] = conditions.toJSONArray();
            parameters["actions"] = actions.toJSONArray();
            
            Alamofire.request(.POST, url, parameters: parameters, encoding: .json)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    public func updateRuleWithId(_ identifier: String, newName: String, newConditions: [RuleCondition]?, newActions: [RuleAction]?, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = self.bridgeAccessConfig {
            
            var parameters = [String: AnyObject]()
            let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/rules/\(identifier)"
            
            parameters["name"] = newName;
            parameters["conditions"] = newConditions?.toJSONArray();
            parameters["actions"] = newActions?.toJSONArray();
            
            Alamofire.request(.PUT, url, parameters: parameters, encoding: .json)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    public func removeRuleWithId(_ identifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        remove(.rule, withIdentifier: identifier, completionHandler: completionHandler)
    }
    
    // MARK: Schedules
    
    public func createScheduleWithName(_ name: String, andCommand command: ScheduleCommand, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = self.bridgeAccessConfig {
            
            var parameters = [String: AnyObject]()
            let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/schedules"
            
            parameters["name"] = name;
            parameters["command"] = command.toJSON();
            
            Alamofire.request(.POST, url, parameters: parameters, encoding: .json)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    public func updateScheduleWithId(_ identifier: String, newName: String, newCommand: ScheduleCommand, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        if let bridgeAccessConfig = self.bridgeAccessConfig {
            
            var parameters = [String: AnyObject]()
            let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/schedules/\(identifier)"

            parameters["name"] = newName;
            parameters["command"] = newCommand.toJSON();
            
            Alamofire.request(.PUT, url, parameters: parameters, encoding: .json)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
    public func removeScheduleWithId(_ identifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        remove(.schedule, withIdentifier: identifier, completionHandler: completionHandler)
    }
    
    // MARK: Sensors
    
    public func removeSensorWithId(_ identifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        remove(.sensor, withIdentifier: identifier, completionHandler: completionHandler)
    }
    
    // MARK: Whitelist Entry
    
    public func removeWhitelistEntryWithId(_ identifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        remove(.whitelistEntry, withIdentifier: identifier, completionHandler: completionHandler)
    }

    // MARK: Helpers
    
    private func errorsFromResponse(_ response: Response<AnyObject, NSError>) -> [Error]? {
        
        var errors: [Error]?
        if let responseItemJSONs = response.result.value as? [JSON] {
            
            errors = [Error].fromJSONArray(responseItemJSONs)
        }
        
        return errors?.count > 0 ? errors : nil
    }
    
    private func remove(_ bridgeResourceType: BridgeResourceType, withIdentifier identifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        let resourceTypeForURL = bridgeResourceType == .whitelistEntry
                                 ? "config/whitelist"
                                 : "\(bridgeResourceType)s"

        if let bridgeAccessConfig = self.bridgeAccessConfig {
            let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/\(resourceTypeForURL)/\(identifier)"

            Alamofire.request(.DELETE, url, encoding: .json)
                .responseJSON { response in
                    
                    completionHandler(errors: self.errorsFromResponse(response))
            }
            
        } else {
            
            completionHandler(errors: [Error(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
        }
    }
    
}
