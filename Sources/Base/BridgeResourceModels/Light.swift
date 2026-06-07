//
//  Light.swift
//  Pods
//
//  Created by Marcel Dittmann on 21.04.16.
//
//

import Foundation

public class Light: BridgeResource, BridgeResourceDictGenerator {

    public typealias AssociatedBridgeResourceType = Light

    public var resourceType: BridgeResourceType { .light }

    public let identifier: String
    public let name: String
    public let state: LightState
    public let type: String
    public let modelId: String
    public let uniqueId: String
    public let manufacturerName: String
    public let luminaireUniqueId: String?
    public let swVersion: String
    public let pointsymbol: String?

    public required init?(json: [String: Any]) {
        guard let identifier = json["id"] as? String,
              let name = json["name"] as? String,
              let stateJSON = json["state"] as? [String: Any],
              let state = LightState(json: stateJSON),
              let type = json["type"] as? String,
              let modelid = json["modelid"] as? String,
              let uniqueid = json["uniqueid"] as? String,
              let manufacturername = json["manufacturername"] as? String,
              let swversion = json["swversion"] as? String else {
            print("Can't create Light from JSON:\n \(json)")
            return nil
        }

        self.identifier = identifier
        self.name = name
        self.state = state
        self.type = type
        self.modelId = modelid
        self.uniqueId = uniqueid
        self.manufacturerName = manufacturername
        self.swVersion = swversion
        self.luminaireUniqueId = json["luminaireuniqueid"] as? String
        self.pointsymbol = json["pointsymbol"] as? String
    }

    public func toJSON() -> [String: Any]? {
        var json: [String: Any] = [
            "id": identifier,
            "name": name,
            "type": type,
            "modelid": modelId,
            "uniqueid": uniqueId,
            "manufacturername": manufacturerName,
            "swversion": swVersion
        ]
        if let stateJSON = state.toJSON() { json["state"] = stateJSON }
        if let luminaireUniqueId { json["luminaireuniqueid"] = luminaireUniqueId }
        if let pointsymbol { json["pointsymbol"] = pointsymbol }
        return json
    }
}

extension Light: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(Int(self.identifier)!)
    }
}

public func ==(lhs: Light, rhs: Light) -> Bool {
    lhs.identifier == rhs.identifier
}
