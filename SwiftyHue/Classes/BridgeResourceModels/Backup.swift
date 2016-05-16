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
    
    case None, ExportFailed, ImportFailed
}

public struct Backup: Decodable, Encodable {
    
    public let status: BackupStatus?
    public let errorcode: BackupError?
    
    public init?(json: JSON) {
        
        status = "status" <~~ json
        errorcode = "errorcode" <~~ json
        
    }
    
    public func toJSON() -> JSON? {
        
        var json = jsonify([
            "status" ~~> self.status,
            "errorcode" ~~> self.errorcode
            ])
        
        return json
    }
}