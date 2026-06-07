//
//  Schedule.swift
//
//
//  Created by Jerome Schmitz on 05.05.16.
//
//

import Foundation

public class Schedule: BridgeResource, BridgeResourceDictGenerator {

    public typealias AssociatedBridgeResourceType = Schedule

    public var resourceType: BridgeResourceType { .schedule }

    public let identifier: String
    public let name: String
    public let scheduleDescription: String
    public let command: ScheduleCommand
    public let localtime: String?
    public let status: String
    public let autodelete: Bool?
    public let recycle: Bool?

    public required init?(json: [String: Any]) {
        guard let identifier = json["id"] as? String else {
            print("Can't create Schedule, missing required attribute \"id\" in JSON:\n \(json)"); return nil
        }
        guard let name = json["name"] as? String else {
            print("Can't create Schedule, missing required attribute \"name\" in JSON:\n \(json)"); return nil
        }
        guard let scheduleDescription = json["description"] as? String else {
            print("Can't create Schedule, missing required attribute \"description\" in JSON:\n \(json)"); return nil
        }
        guard let commandJSON = json["command"] as? [String: Any],
              let command = ScheduleCommand(json: commandJSON) else {
            print("Can't create Schedule, missing required attribute \"command\" in JSON:\n \(json)"); return nil
        }
        guard let status = json["status"] as? String else {
            print("Can't create Schedule, missing required attribute \"status\" in JSON:\n \(json)"); return nil
        }

        self.identifier = identifier
        self.name = name
        self.scheduleDescription = scheduleDescription
        self.command = command
        self.status = status
        self.recycle = json["recycle"] as? Bool
        self.autodelete = json["autodelete"] as? Bool
        self.localtime = json["localtime"] as? String
    }

    public func toJSON() -> [String: Any]? {
        var json: [String: Any] = [
            "id": identifier,
            "name": name,
            "description": scheduleDescription,
            "status": status
        ]
        if let commandJSON = command.toJSON() { json["command"] = commandJSON }
        if let localtime { json["localtime"] = localtime }
        if let autodelete { json["autodelete"] = autodelete }
        if let recycle { json["recycle"] = recycle }
        return json
    }
}

extension Schedule: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(1)
    }
}

public func ==(lhs: Schedule, rhs: Schedule) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.name == rhs.name &&
        lhs.scheduleDescription == rhs.scheduleDescription &&
        lhs.command == rhs.command &&
        lhs.status == rhs.status &&
        lhs.recycle == rhs.recycle &&
        lhs.autodelete == rhs.autodelete &&
        lhs.localtime == rhs.localtime
}
