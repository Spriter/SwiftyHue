//
//  Schedule.swift
//
//
//  Created by Jerome Schmitz on 05.05.16.
//
//

import Foundation
import Gloss

public class Schedule: BridgeResource, BridgeResourceDictGenerator {
    
    public typealias AssociatedBridgeResourceType = Schedule
    
    public var resourceType: BridgeResourceType {
        return .schedule
    };
    
    public let identifier: String
    public let name: String
    public let scheduleDescription: String
    public let command: ScheduleCommand
    public let localtime: String?
    public let status: String
    public let autodelete: Bool?
    public let recycle: Bool?
    
    public required init?(json: JSON) {
        
        guard let identifier: String = "id" <~~ json else {
            print("Can't create Schedule, missing required attribute \"id\" in JSON:\n \(json)"); return nil
        }
        
        guard let name: String = "name" <~~ json else {
            print("Can't create Schedule, missing required attribute \"name\" in JSON:\n \(json)"); return nil
        }
        
        guard let scheduleDescription: String = "description" <~~ json else {
            print("Can't create Schedule, missing required attribute \"description\" in JSON:\n \(json)"); return nil
        }
        
        guard let command: ScheduleCommand = "command" <~~ json else {
            print("Can't create Schedule, missing required attribute \"command\" in JSON:\n \(json)"); return nil
        }
        
        guard let status: String = "status" <~~ json else {
            print("Can't create Schedule, missing required attribute \"status\" in JSON:\n \(json)"); return nil
        }
        
        self.identifier = identifier
        self.name = name
        self.scheduleDescription = scheduleDescription
        self.command = command
        self.status = status
        self.recycle = "recycle" <~~ json
        self.autodelete = "autodelete" <~~ json
        self.localtime = "localtime" <~~ json
    }
    
    public func toJSON() -> JSON? {
        
        let json = jsonify([
            "id" ~~> identifier,
            "name" ~~> name,
            "description" ~~> scheduleDescription,
            "command" ~~> command,
            "localtime" ~~> localtime,
            "status" ~~> status,
            "autodelete" ~~> autodelete,
            "recycle" ~~> recycle
            ])
        
        return json
    }
}

extension Schedule: Hashable {
    
    public var hashValue: Int {
        
        return 1
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
