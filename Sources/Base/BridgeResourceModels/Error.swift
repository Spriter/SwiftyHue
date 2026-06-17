//
//  Error.swift
//  Pods
//
//  Created by Marcel Dittmann on 29.04.16.
//
//

import Foundation

public enum SHErrorType: Int {
    case unknownError = 0
    case unauthorizedUser = 1
    case bodyContainsInvalidJSON = 2
    case resourceNotAvailable = 3
    case methodNotAvailableForResource = 4
    case missingParametersBody = 5
    case parameterNotAvailable = 6
    case invalidValueParameter = 7
    case parameterIsNotModifiable = 8
    case tooManyItemsInList = 9
    case portalConnectionRequired = 10
    case internalError = 901
}

public class HueError: NSError, @unchecked Sendable {
    
    public let address: String
    public let errorDescription: String
    public let type: SHErrorType
    
    public required init?(json: JSON) {
        if json["success"] != nil {
            return nil
        }

        guard
            let errorJSON = json["error"] as? JSON,
            let type = errorJSON["type"] as? Int,
            let address = errorJSON["address"] as? String,
            let errorDescription = errorJSON["description"] as? String
        else {
            print("Can't create Error Object from JSON:\n \(json)")
            return nil
        }
        
        if let type = SHErrorType(rawValue: type) {
            self.type = type
        } else {
            self.type = .unknownError
        }
        
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
