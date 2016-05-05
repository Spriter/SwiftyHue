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

public struct BridgeSendAPI {
  
    static private var bridgeAcc = "hkoPdsoXKRVsbI6wcPWdcu4ud0jnIEhfoP4GftxY";
    static private var bridgeIp = "192.168.0.10"
    
    public typealias BridgeSendErrorArrayCompletionHandler = (errors: [Error]?) -> Void
//    public typealias PHBridgeSendDictionaryCompletionHandler = (dictionary: [String: AnyObject], errors: [Error]?) -> Void
    
    // MARK: Scenes
    
    public static func recallSceneWithIdentifier(identifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        let parameters = ["scene": identifier]
        
        Alamofire.request(.PUT, "http://\(bridgeIp)/api/\(bridgeAcc)/groups/0/action", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                
                completionHandler(errors: self.errorsFromResponse(response))
        }
    }
    
    public static func recallSceneWithIdentifier(identifier: String, inGroupWithIdentifier groupIdentifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        let parameters = ["scene": identifier]
        
        Alamofire.request(.PUT, "http://\(bridgeIp)/api/\(bridgeAcc)/groups/\(groupIdentifier)/action", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                
                completionHandler(errors: self.errorsFromResponse(response))
        }
    }
    
    /**
     Creates the given scene with all lights in the provided lights resource. For a given scene the current light settings of the given lights resources are stored. If the scene id is recalled in the future, these light settings will be reproduced on these lamps. If an existing name is used then the settings for this scene will be overwritten and the light states resaved. The bridge can support up to 200 scenes, however please also note there is a maximum of 2048 scene lightstates so for example, of all your scenes have 20 lightstates, the maximum number of allowed scenes will be 102.
     */
    public static func createSceneWithName(name: String, inlcudeLightIds lightIds: [String], recycle: Bool = false, transitionTime: Int? = nil, picture: String? = nil, appData: AppData? = nil, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        var parameters: [String: AnyObject] = ["name": name, "lights": lightIds, "recycle": recycle];
        
        parameters["transitiontime"] = transitionTime
        parameters["picture"] = picture
        parameters["appdata"] = appData?.toJSON()
        
        Alamofire.request(.POST, "http://\(bridgeIp)/api/\(bridgeAcc)/scenes", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                
                completionHandler(errors: self.errorsFromResponse(response))
        }
    }
    
    // MARK: Lights
    
    public static func updateLightStateForId(identifier: String, withLightState lightState: LightState, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        let parameters = lightState.toJSON()!
        
        Alamofire.request(.PUT, "http://\(bridgeIp)/api/\(bridgeAcc)/lights/\(identifier)/state", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
             
                completionHandler(errors: self.errorsFromResponse(response))
        }
    }
    
    // MARK: Groups
    
    public static func createRoomWithName(name: String, andType type: GroupType, andRoomClass roomClass: RoomClass, inlcudeLightIds lightIds: [String], completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        let parameters: [String: AnyObject] = ["name": name, "class": roomClass.rawValue, "type": type.rawValue
            , "lights": lightIds]
        
        Alamofire.request(.POST, "http://\(bridgeIp)/api/\(bridgeAcc)/groups", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                
                completionHandler(errors: self.errorsFromResponse(response))
        }
    }
    
    public static func createGroupWithName(name: String, andType type: GroupType, inlcudeLightIds lightIds: [String], completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        let parameters: [String: AnyObject] = ["name": name, "type": type.rawValue
            , "lights": lightIds]
        
        Alamofire.request(.POST, "http://\(bridgeIp)/api/\(bridgeAcc)/groups", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                
                completionHandler(errors: self.errorsFromResponse(response))
        }
    }
    
    /** 
     Allows the user to modify the name and the lights of a group
    */
    public static func updateGroupWithId(identifier: String, newName: String?, newLightIdentifiers: [String]?, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        var parameters = [String: AnyObject]()
        
        parameters["name"] = newName;
        parameters["lights"] = newLightIdentifiers;
        
        Alamofire.request(.PUT, "http://\(bridgeIp)/api/\(bridgeAcc)/groups/\(identifier)", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                
                completionHandler(errors: self.errorsFromResponse(response))
        }
    }
    
    /**
     Allows the user to modify the name and the lights of a group
     */
    public static func updateRoomWithId(identifier: String, newName: String?, newLightIdentifiers: [String]?, newRoomClass: RoomClass?, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        var parameters = [String: AnyObject]()
        
        parameters["name"] = newName;
        parameters["class"] = newRoomClass?.rawValue;
        parameters["lights"] = newLightIdentifiers;
        
        Alamofire.request(.PUT, "http://\(bridgeIp)/api/\(bridgeAcc)/groups/\(identifier)", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                
                completionHandler(errors: self.errorsFromResponse(response))
        }
    }
    
    public static func removeGroupWithId(identifier: String, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        Alamofire.request(.DELETE, "http://\(bridgeIp)/api/\(bridgeAcc)/groups/\(identifier)", encoding: .JSON)
            .responseJSON { response in
                
                completionHandler(errors: self.errorsFromResponse(response))
        }
    }
    
    public static func setLightStateForGroupWithId(identifier: String, withLightState lightState: LightState, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        let parameters = lightState.toJSON()!
        
        Alamofire.request(.PUT, "http://\(bridgeIp)/api/\(bridgeAcc)/groups/\(identifier)/action", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                
                completionHandler(errors: self.errorsFromResponse(response))
        }
    }

    // MARK: Helpers
    
    private static func errorsFromResponse(response: Response<AnyObject, NSError>) -> [Error]? {
        
        var errors: [Error]?
        if let responseItemJSONs = response.result.value as? [JSON] {
            
            errors = [Error].fromJSONArray(responseItemJSONs)
        }
        
        return errors?.count > 0 ? errors : nil
    }
    
    
}