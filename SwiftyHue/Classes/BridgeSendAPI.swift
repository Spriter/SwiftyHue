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
    
    public static func updateLightStateForId(identifier: String, withLightState lightState: LightState, completionHandler: BridgeSendErrorArrayCompletionHandler) {
        
        let parameters = lightState.toJSON()!
        
        Alamofire.request(.PUT, "http://\(bridgeIp)/api/\(bridgeAcc)/lights/\(identifier)/state", parameters: parameters, encoding: .JSON)
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
        
        if let name = newName {
            parameters["name"] = name;
        }
        if let lightIdentifiers = newLightIdentifiers {
            parameters["lights"] = lightIdentifiers;
        }
        
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

    private static func errorsFromResponse(response: Response<AnyObject, NSError>) -> [Error]? {
        
        var errors: [Error]?
        if let responseItemJSONs = response.result.value as? [JSON] {
            
            errors = [Error].fromJSONArray(responseItemJSONs)
        }
        
        return errors?.count > 0 ? errors : nil
    }
    
    
}