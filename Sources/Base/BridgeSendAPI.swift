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
  
    //    public typealias PHBridgeSendDictionaryCompletionHandler = (dictionary: [String: Any], errors: [Error]?) -> Void
    public typealias BridgeSendErrorArrayCompletionHandler = (_ errors: [Error]?) -> Void
    
    private var bridgeAccessConfig: BridgeAccessConfig?;
    
    init() {
        
    }
    
    func setBridgeAccessConfig(_ bridgeAccessConfig: BridgeAccessConfig) {
        
        self.bridgeAccessConfig = bridgeAccessConfig
    }
    
    // MARK: Scenes
    
    public func recallSceneWithIdentifier(_ identifier: String, completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        let parameters = ["scene": identifier]
        
        guard let bridgeAccessConfig = bridgeAccessConfig else {
            completionHandler([HueError(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
            return
        }

        let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups/0/action"

        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                completionHandler(self.errorsFromResponse(response))
        }

    }
    
    public func recallSceneWithIdentifier(_ identifier: String, inGroupWithIdentifier groupIdentifier: String, completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        guard let bridgeAccessConfig = bridgeAccessConfig else{
            completionHandler([HueError(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
            return
        }

        let parameters = ["scene": identifier]
        let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups/\(groupIdentifier)/action"

        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                completionHandler(self.errorsFromResponse(response))
        }
    }
    
    /**
     Creates the given scene with all lights in the provided lights resource. For a given scene the current light settings of the given lights resources are stored. If the scene id is recalled in the future, these light settings will be reproduced on these lamps. If an existing name is used then the settings for this scene will be overwritten and the light states resaved. The bridge can support up to 200 scenes, however please also note there is a maximum of 2048 scene lightstates so for example, of all your scenes have 20 lightstates, the maximum number of allowed scenes will be 102.
     */
    public func createSceneWithName(_ name: String, includeLightIds lightIds: [String], recycle: Bool = false, transitionTime: Int? = nil, picture: String? = nil, appData: AppData? = nil, completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        guard let bridgeAccessConfig = bridgeAccessConfig else{
            completionHandler([HueError(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
            return
        }

        var parameters: [String: Any] = ["name": name, "lights": lightIds, "recycle": recycle];
        let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/scenes"

        parameters["transitiontime"] = transitionTime
        parameters["picture"] = picture
        parameters["appdata"] = appData?.toJSON()

        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                completionHandler(self.errorsFromResponse(response))
        }

    }
    
    public func updateLightStateInScene(_ sceneIdentifier: String, lightIdentifier: String, withLightState lightState: LightState, completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        guard let bridgeAccessConfig = bridgeAccessConfig else {
            completionHandler([HueError(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
            return
        }
        
        let parameters = lightState.toJSON()!
        
        let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/scenes/\(sceneIdentifier)/lightstate/\(lightIdentifier)"
        
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                completionHandler(self.errorsFromResponse(response))
        }
    }

    public func removeSceneWithId(_ identifier: String, completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {

        remove(.scene, withIdentifier: identifier, completionHandler: completionHandler)
    }
    
    // MARK: Lights
    
    public func updateLightStateForId(_ identifier: String, withLightState lightState: LightState, transitionTime: Int? = nil, completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        guard let bridgeAccessConfig = bridgeAccessConfig else {
            completionHandler([HueError(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
            return
        }

        var parameters = lightState.toJSON()!

        if let transitionTime = transitionTime{
            parameters["transitiontime"] = transitionTime
        }

        let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/lights/\(identifier)/state"

        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                completionHandler(self.errorsFromResponse(response))
        }
    }
    
    public func removeLightWithId(_ identifier: String, completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        remove(.light, withIdentifier: identifier, completionHandler: completionHandler)
    }
    
    // MARK: Groups
    
    public func createRoomWithName(_ name: String, andType type: GroupType, andRoomClass roomClass: RoomClass, includeLightIds lightIds: [String], completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        guard let bridgeAccessConfig = self.bridgeAccessConfig else {
            completionHandler([HueError(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
            return
        }

        let parameters: [String: Any] = ["name": name, "class": roomClass.rawValue, "type": type.rawValue
            , "lights": lightIds]
        let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups"
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                completionHandler(self.errorsFromResponse(response))
        }

    }
    
    public func createGroupWithName(_ name: String, andType type: GroupType, includeLightIds lightIds: [String], completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        guard let bridgeAccessConfig = self.bridgeAccessConfig else {
            completionHandler([HueError(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
            return
        }

        let parameters: [String: Any] = ["name": name, "type": type.rawValue
            , "lights": lightIds]
        let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups"

        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                completionHandler(self.errorsFromResponse(response))
        }
    }
    
    /** 
     Allows the user to modify the name and the lights of a group
    */
    public func updateGroupWithId(_ identifier: String, newName: String?, newLightIdentifiers: [String]?, completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        guard let bridgeAccessConfig = self.bridgeAccessConfig else {
            completionHandler([HueError(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
            return
        }

        var parameters = [String: Any]()
        let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups/\(identifier)"
        parameters["name"] = newName;
        parameters["lights"] = newLightIdentifiers;
        
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                completionHandler(self.errorsFromResponse(response))
        }

    }
    
    /**
     Allows the user to modify the name and the lights of a group
     */
    public func updateRoomWithId(_ identifier: String, newName: String?, newLightIdentifiers: [String]?, newRoomClass: RoomClass?, completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        guard let bridgeAccessConfig = self.bridgeAccessConfig else{
            completionHandler([HueError(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
            return
        }

        var parameters = [String: Any]()
        let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups/\(identifier)"

        parameters["name"] = newName;
        parameters["class"] = newRoomClass?.rawValue;
        parameters["lights"] = newLightIdentifiers;
        
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                completionHandler(self.errorsFromResponse(response))
        }
    }
    
    public func removeGroupWithId(_ identifier: String, completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        remove(.group, withIdentifier: identifier, completionHandler: completionHandler)
    }
    
    public func setLightStateForGroupWithId(_ identifier: String, withLightState lightState: LightState, completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        guard let bridgeAccessConfig = self.bridgeAccessConfig else{
            completionHandler([HueError(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
            return
        }

        let parameters = lightState.toJSON()!
        let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/groups/\(identifier)/action"
        
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                completionHandler(self.errorsFromResponse(response))
        }
    }
    
    // MARK: Rules
    
    public func createRuleWithName(_ name: String, andConditions conditions: [RuleCondition], andActions actions: [RuleAction], completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        guard let bridgeAccessConfig = self.bridgeAccessConfig else {
            completionHandler([HueError(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
            return
        }

        var parameters = [String: Any]()
        let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/rules"

        parameters["name"] = name;
        parameters["conditions"] = conditions.toJSONArray();
        parameters["actions"] = actions.toJSONArray();
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                completionHandler(self.errorsFromResponse(response))
        }

    }
    
    public func updateRuleWithId(_ identifier: String, newName: String, newConditions: [RuleCondition]?, newActions: [RuleAction]?, completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        guard let bridgeAccessConfig = self.bridgeAccessConfig else {
            completionHandler([HueError(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
            return
        }

        var parameters = [String: Any]()
        let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/rules/\(identifier)"
        
        parameters["name"] = newName;
        parameters["conditions"] = newConditions?.toJSONArray();
        parameters["actions"] = newActions?.toJSONArray();
        
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                completionHandler(self.errorsFromResponse(response))
        }
    }
    
    public func removeRuleWithId(_ identifier: String, completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        remove(.rule, withIdentifier: identifier, completionHandler: completionHandler)
    }
    
    // MARK: Schedules
    
    public func createScheduleWithName(_ name: String, andCommand command: ScheduleCommand, completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        guard let bridgeAccessConfig = self.bridgeAccessConfig else {
            completionHandler([HueError(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
            return
        }

        var parameters = [String: Any]()
        let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/schedules"
        
        parameters["name"] = name;
        parameters["command"] = command.toJSON();
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                completionHandler(self.errorsFromResponse(response))
        }
    }
    
    public func updateScheduleWithId(_ identifier: String, newName: String, newCommand: ScheduleCommand, completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        guard let bridgeAccessConfig = self.bridgeAccessConfig else {
            completionHandler([HueError(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
            return
        }

        var parameters = [String: Any]()
        let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/schedules/\(identifier)"

        parameters["name"] = newName;
        parameters["command"] = newCommand.toJSON();
        
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                completionHandler(self.errorsFromResponse(response))
        }
    }
    
    public func removeScheduleWithId(_ identifier: String, completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        remove(.schedule, withIdentifier: identifier, completionHandler: completionHandler)
    }
    
    // MARK: Sensors
    
    public func removeSensorWithId(_ identifier: String, completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        remove(.sensor, withIdentifier: identifier, completionHandler: completionHandler)
    }
    
    // MARK: Whitelist Entry
    
    public func removeWhitelistEntryWithId(_ identifier: String, completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        remove(.whitelistEntry, withIdentifier: identifier, completionHandler: completionHandler)
    }

    // MARK: Helpers
    
    private func errorsFromResponse(_ response: DataResponse<Any>) -> [Error]? {
        
        var errors: [HueError]?
        if let responseItemJSONs = response.result.value as? [JSON] {
            
            errors = [HueError].from(jsonArray: responseItemJSONs)
        }
        
        if let errors = errors, errors.count > 0 {
            return errors
        }
        
        return nil
    }
    
    private func remove(_ bridgeResourceType: BridgeResourceType, withIdentifier identifier: String, completionHandler: @escaping BridgeSendErrorArrayCompletionHandler) {
        
        let resourceTypeForURL = bridgeResourceType == .whitelistEntry
                                 ? "config/whitelist"
                                 : "\(bridgeResourceType)s"

        guard let bridgeAccessConfig = self.bridgeAccessConfig else {
            completionHandler([HueError(address: "SwiftyHue", errorDescription: "No bridgeAccessConfig available", type: 1)!])
            return
        }

        let url = "http://\(bridgeAccessConfig.ipAddress)/api/\(bridgeAccessConfig.username)/\(resourceTypeForURL)/\(identifier)"

        Alamofire.request(url, method: .delete, encoding: JSONEncoding.default)
            .responseJSON { response in
                
            completionHandler(self.errorsFromResponse(response))
        }
    }
    
}
