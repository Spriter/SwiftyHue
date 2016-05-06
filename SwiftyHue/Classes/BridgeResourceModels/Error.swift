//
//  Error.swift
//  Pods
//
//  Created by Marcel Dittmann on 29.04.16.
//
//

import Foundation
import Gloss

public class Error: NSError, Decodable {
    
    public let address: String
    public let errorDescription: String
    public let type: Int
    
    public required init?(json: JSON) {

        guard let type: Int = "error.type" <~~ json,
            let address: String = "error.address" <~~ json,
            let errorDescription: String = "error.description" <~~ json
            else { return nil }
        
        self.type = type
        self.address = address
        self.errorDescription = errorDescription
        
        super.init(domain: address, code: type, userInfo: ["description": errorDescription])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}