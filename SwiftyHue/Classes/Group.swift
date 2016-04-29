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

    public typealias BridgeResourceType = Group;

    public var identifier: String
    public var name: String
    
    /**
        The light state of one of the lamps in the group.
     */
    public let action: LightState?;
    
    /**
        The IDs of the lights that are in the group.
     */
    public let lightIdentifiers: [String]?;
    
    /**
        As of 1.4. If not provided upon creation "LightGroup" is used. Can be "LightGroup", "Room" or either "Luminaire" or "LightSource" if a Multisource Luminaire is present in the system.
     */
    public let type: GroupType?
    
    /**
        As of 1.4. Uniquely identifies the hardware model of the luminaire. Only present for automatically created Luminaires.
     */
    public let modelid: String?
    
    /**
        As of 1.9. Unique Id in AA:BB:CC:DD format for Luminaire groups or AA:BB:CC:DD-XX format for Lightsource groups, where XX is the lightsource position.
     */
    public let uniqueid: String?
    
    /**
        As of 1.11. Category of Room types. Default is: Other.
     */
    public let roomClass: RoomClass?
    
    public required init?(json: JSON) {
        
        guard let identifier: String = "id" <~~ json,
              let name: String = "name" <~~ json
            else { return nil }
        
        self.identifier = identifier
        self.name = name
        
        action = "action" <~~ json
        lightIdentifiers = "lights" <~~ json
        type = "type" <~~ json
        modelid = "modelid" <~~ json
        uniqueid = "uniqueid" <~~ json
        roomClass = RoomClass(rawValue: ("class" <~~ json) ?? "Other")
        
        //super.init(json: json)
    }
    
    public func toJSON() -> JSON? {
//   
//        var supersJSON = super.toJSON()
//        
//        var json = jsonify([
//            "action" ~~> self.identifier,
//            "lights" ~~> self.lightIdentifiers,
//            "type" ~~> self.type,
//            "modelid" ~~> self.modelid,
//            "uniqueid" ~~> self.uniqueid,
//            "class" ~~> self.roomClass?.rawValue
//            ])
//        
//        if (json != nil && supersJSON != nil) {
//            
//            json!.add(supersJSON!)
//        }
        
        return nil
    }

}