//
//  Group.swift
//  Pods
//
//  Created by Marcel Dittmann on 21.04.16.
//
//

import Foundation
import Gloss

public enum GroupType: String {
    
    case LightGroup, Room, Luminaire, LightSource
}

public enum RoomClass: String {
    
    case LivingRoom = "Living room", Kitchen, Dining, Bedroom, KidsBedroom = "Kids bedroom", Bathroom, Nursery, Recreation, Office, Gym, Hallway, Toilet, FrontDoor = "Front door", Garage, Terrace, Garden, Driveway, Carport, Other
}

public class Group: BridgeResourceDictGenerator, BridgeResource {
    
    public typealias AssociatedBridgeResourceType = Group;

    public var resourceType: BridgeResourceType {
        return .group
    };
    
    public var identifier: String
    public var name: String
    
    /**
        The light state of one of the lamps in the group.
     */
    public let action: LightState;
    
    /**
        The IDs of the lights that are in the group.
     */
    public let lightIdentifiers: [String]?;
    
    /**
        As of 1.4. If not provided upon creation "LightGroup" is used. Can be "LightGroup", "Room" or either "Luminaire" or "LightSource" if a Multisource Luminaire is present in the system.
     */
    public let type: GroupType
    
    /**
        As of 1.4. Uniquely identifies the hardware model of the luminaire. Only present for automatically created Luminaires.
     */
    public let modelId: String?
    
    /**
        As of 1.9. Unique Id in AA:BB:CC:DD format for Luminaire groups or AA:BB:CC:DD-XX format for Lightsource groups, where XX is the lightsource position.
     */
    public let uniqueId: String?
    
    /**
        As of 1.11. Category of Room types. Default is: Other.
     */
    public let roomClass: RoomClass
    
    public required init?(json: JSON) {
        
        guard let identifier: String = "id" <~~ json,
            let name: String = "name" <~~ json,
            let action: LightState = "action" <~~ json,
            let type: GroupType = "type" <~~ json,
            let roomClass: RoomClass = RoomClass(rawValue: ("class" <~~ json) ?? "Other")
        
            else { Log.error("Can't create Group from JSON:\n \(json)"); return nil }
        
        self.identifier = identifier
        self.name = name
        self.action = action
        self.type = type
        self.roomClass = roomClass
        
        uniqueId = "uniqueid" <~~ json
        modelId = "modelid" <~~ json
        lightIdentifiers = "lights" <~~ json
    }
    
    public func toJSON() -> JSON? {
   
        let json = jsonify([
            "id" ~~> identifier,
            "name" ~~> name,
            "action" ~~> action,
            "lights" ~~> lightIdentifiers,
            "type" ~~> type,
            "modelid" ~~> modelId,
            "uniqueid" ~~> uniqueId,
            "class" ~~> roomClass.rawValue
            ])
        
        return json
    }

}

extension Group: Hashable {
    
    public var hashValue: Int {
        
        return Int(self.identifier)!
    }
}

public func ==(lhs: Group, rhs: Group) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.name == rhs.name &&
        lhs.action == rhs.action &&
        (lhs.lightIdentifiers ?? []) == (rhs.lightIdentifiers ?? []) &&
        lhs.type == rhs.type &&
        lhs.modelId == rhs.modelId &&
        lhs.uniqueId == rhs.uniqueId &&
        lhs.roomClass == rhs.roomClass
}
