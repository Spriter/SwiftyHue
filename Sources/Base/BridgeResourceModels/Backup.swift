//
//  Backup.swift
//  Pods
//
//  Created by Marcel Dittmann on 22.04.16.
//
//

import Foundation

public enum BackupStatus: String, Codable {
    case idle, startmigration, fileready_disabled, prepare_restore, restoring
}

public enum BackupError: Int, Codable {
    case none, exportFailed, importFailed
}

public struct Backup: Codable {

    public let status: BackupStatus?
    public let errorcode: BackupError?

    public init?(json: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: json),
              let decoded = try? JSONDecoder().decode(Backup.self, from: data) else {
            return nil
        }
        self = decoded
    }

    public func toJSON() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let object = try? JSONSerialization.jsonObject(with: data),
              let json = object as? [String: Any] else {
            return nil
        }
        return json
    }
}

extension Backup: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(1)
    }
}

public func ==(lhs: Backup, rhs: Backup) -> Bool {
    return lhs.status == rhs.status && lhs.errorcode == rhs.errorcode
}
