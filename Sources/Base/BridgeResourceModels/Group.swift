//
//  Group.swift
//  Pods
//
//  Created by Marcel Dittmann on 21.04.16.
//
//

import Foundation

public enum GroupType: String {
    case LightGroup, Room, Luminaire, LightSource, Entertainment, Zone
}

public enum RoomClass: String {
    case LivingRoom = "Living room", Kitchen, Dining, Bedroom, KidsBedroom = "Kids bedroom", Bathroom, Nursery, Recreation, Office, Gym, Hallway, Toilet, FrontDoor = "Front door", Garage, Terrace, Garden, Driveway, Carport, Other, Home, Downstairs, Upstairs, TopFloor = "Top floor", Attic, GuestRoom = "Guest room", Staircase, Lounge, ManCave = "Man cave", Computer, Studio, Music, TV, Reading, Closet, Storage, LaundryRoom = "Laundry room", Balcony, Porch, Barbecue, Pool
}

public class Group: BridgeResourceDictGenerator, BridgeResource {

    public typealias AssociatedBridgeResourceType = Group

    public var resourceType: BridgeResourceType { .group }

    public var identifier: String
    public var name: String
    public let action: LightState
    public let lightIdentifiers: [String]?
    public let type: GroupType
    public let modelId: String?
    public let uniqueId: String?
    public let roomClass: RoomClass

    public required init?(json: [String: Any]) {
        guard let identifier = json["id"] as? String,
              let name = json["name"] as? String,
              let actionJSON = json["action"] as? [String: Any],
              let action = LightState(json: actionJSON),
              let typeRaw = json["type"] as? String,
              let type = GroupType(rawValue: typeRaw) else {
            print("Can't create Group from JSON:\n \(json)")
            return nil
        }

        let roomClassRaw = (json["class"] as? String) ?? "Other"
        let roomClass = RoomClass(rawValue: roomClassRaw) ?? .Other

        self.identifier = identifier
        self.name = name
        self.action = action
        self.type = type
        self.roomClass = roomClass
        self.uniqueId = json["uniqueid"] as? String
        self.modelId = json["modelid"] as? String
        self.lightIdentifiers = json["lights"] as? [String]
    }

    public func toJSON() -> [String: Any]? {
        var json: [String: Any] = [
            "id": identifier,
            "name": name,
            "type": type.rawValue,
            "class": roomClass.rawValue
        ]
        if let actionJson = action.toJSON() { json["action"] = actionJson }
        if let lightIdentifiers { json["lights"] = lightIdentifiers }
        if let modelId { json["modelid"] = modelId }
        if let uniqueId { json["uniqueid"] = uniqueId }
        return json
    }
}

extension Group: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(Int(self.identifier)!)
    }
}

public func ==(lhs: Group, rhs: Group) -> Bool {
    lhs.identifier == rhs.identifier
}
