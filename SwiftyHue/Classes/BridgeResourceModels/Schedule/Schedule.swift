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
    
    public let identifier: String
    public let name: String
    public let scheduleDescription: String
    public let command: ScheduleCommand
    public let localtime: String
    public let status: String
    public let autodelete: Bool
    
    public required init?(json: JSON) {
        
        guard let identifier: String = "id" <~~ json,
            let name: String = "name" <~~ json,
            let scheduleDescription: String = "description" <~~ json,
            let command: ScheduleCommand = "command" <~~ json,
            let localtime: String = "localtime" <~~ json,
            let status: String = "status" <~~ json,
            let autodelete: Bool = "autodelete" <~~ json
            
            else { return nil }
        
        self.identifier = identifier
        self.name = name
        self.scheduleDescription = scheduleDescription
        self.command = command
        self.localtime = localtime
        self.status = status
        self.autodelete = autodelete
    }
    
    public func toJSON() -> JSON? {
        
        let json = jsonify([
            "id" ~~> self.identifier,
            "name" ~~> self.name,
            "scheduleDescription" ~~> self.scheduleDescription,
            "command" ~~> self.command,
            "localtime" ~~> self.localtime,
            "status" ~~> self.status,
            "autodelete" ~~> self.autodelete
            ])
        
        return json
    }
}
