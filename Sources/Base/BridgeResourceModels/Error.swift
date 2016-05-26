//
//  Error.swift
//  Pods
//
//  Created by Marcel Dittmann on 29.04.16.
//
//

import Foundation
import Gloss

public enum SHErrorType: Int {
    
    case unauthorizedUser = 1
}

public class Error: NSError, Decodable {
    
    public let address: String
    public let errorDescription: String
    public let type: SHErrorType
    
    public required init?(json: JSON) {

        guard let type: Int = "error.type" <~~ json,
            let address: String = "error.address" <~~ json,
            let errorDescription: String = "error.description" <~~ json
            else { Log.error("Can't create Error Object from JSON:\n \(json)"); return nil }
        
        self.type = SHErrorType(rawValue: type)!
        self.address = address
        self.errorDescription = errorDescription
        
        super.init(domain: address, code: type, userInfo: ["description": errorDescription])
    }
    
    public init(address: String, errorDescription: String, type: SHErrorType) {
        
        self.type = type
        self.address = address
        self.errorDescription = errorDescription
        
        super.init(domain: address, code: type.rawValue, userInfo: ["description": errorDescription])
    }

    public init?(address: String, errorDescription: String, type: Int) {
        
        guard let errorType = SHErrorType(rawValue: type) else {return nil};
        
        self.type = errorType;
        self.address = address
        self.errorDescription = errorDescription
        
        super.init(domain: address, code: type, userInfo: ["description": errorDescription])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}