//
//  Backup.swift
//  Pods
//
//  Created by Marcel Dittmann on 22.04.16.
//
//

import Foundation
import Gloss

public enum BackupStatus: String {
    
    case idle, startmigration, fileready_disabled, prepare_restore, restoring
}

public enum BackupError: Int {
    
    case none, exportFailed, importFailed
}

public struct Backup: Decodable, Encodable {
    
    public let status: BackupStatus?
    public let errorcode: BackupError?
    
    public init?(json: JSON) {
        
        status = "status" <~~ json
        errorcode = "errorcode" <~~ json
        
    }
    
    public func toJSON() -> JSON? {
        
        let json = jsonify([
            "status" ~~> status,
            "errorcode" ~~> errorcode
            ])
        
        return json
    }
}
extension Backup: Hashable {
    
    public var hashValue: Int {
        
        return 1
    }
}
public func ==(lhs: Backup, rhs: Backup) -> Bool {
    return lhs.status == rhs.status && lhs.errorcode == rhs.errorcode
}
