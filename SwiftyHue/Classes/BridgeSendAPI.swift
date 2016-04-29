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
    
    private static func errorsFromResponse(response: Response<AnyObject, NSError>) -> [Error]? {
        
        var errors: [Error]?
        if let responseItemJSONs = response.result.value as? [JSON] {
            
            errors = [Error].fromJSONArray(responseItemJSONs)
        }
        
        return errors?.count > 0 ? errors : nil
    }
    
    
}