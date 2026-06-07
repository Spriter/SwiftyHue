//
//  BridgeResource.swift
//  Pods
//
//  Created by Marcel Dittmann on 21.04.16.
//
//

import Foundation

public enum BridgeResourceType: String {
    case light, group, scene, sensor, rule, config, schedule, whitelistEntry
}

public protocol BridgeResource {

    init?(json: [String: Any])
    func toJSON() -> [String: Any]?

    var identifier: String { get }
    var name: String { get }
    var resourceType: BridgeResourceType { get }
}

/**
 Can create a dictionary of a specific BridgeResource (BridgeResourceType) from a JSON ([String: AnyObject]).
 */
public protocol BridgeResourceDictGenerator {

    associatedtype AssociatedBridgeResourceType: BridgeResource

    static func dictionaryFromResourcesJSON(_ json: [String: Any]) -> [String: AssociatedBridgeResourceType]
}

public extension BridgeResourceDictGenerator {

    static func dictionaryFromResourcesJSON(_ json: [String: Any]) -> [String: AssociatedBridgeResourceType] {

        var dict: [String: AssociatedBridgeResourceType] = [:]

        for (key, value) in json {
            guard var resourceJSON = value as? [String: Any] else { continue }
            resourceJSON["id"] = key

            if let resource = AssociatedBridgeResourceType(json: resourceJSON) {
                dict[key] = resource
            }
        }

        return dict
    }
}
