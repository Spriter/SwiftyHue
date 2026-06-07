//
//  BridgeResourcesCache.swift
//  Pods
//
//  Created by Marcel Dittmann on 23.04.16.
//
//

import Foundation

public class BridgeResourcesCache {
    
    // MARK: Public Interface
    
    public var lights: [String: Light] {
        return _lights
    };
    public var groups: [String: Group] {
        return _groups
    };
    public var schedules: [String: Schedule] {
        return _schedules
    };
    public var scenes: [String: PartialScene] {
        return _scenes
    };
    public var sensors: [String: Sensor] {
        return _sensors
    };
    public var rules: [String: Rule] {
        return _rules
    };
    public var bridgeConfiguration: BridgeConfiguration? {
        return _bridgeConfiguration
    };
    
    // MARK: Private Properties
    
    private var _lights: [String: Light];
    private var _groups: [String: Group];
    private var _schedules: [String: Schedule];
    private var _scenes: [String: PartialScene];
    private var _sensors: [String: Sensor];
    private var _rules: [String: Rule];
    private var _bridgeConfiguration: BridgeConfiguration?;
    
    // MARK: Init
    
    public init() {
      
        _lights = [String: Light]();
        _groups = [String: Group]();
        _schedules = [String: Schedule]();
        _scenes = [String: PartialScene]();
        _sensors = [String: Sensor]();
        _rules = [String: Rule]();
        _bridgeConfiguration = nil
        
    };
    
    public init(lights: [String: Light], groups: [String: Group], schedules: [String: Schedule], scenes: [String: PartialScene], sensors: [String: Sensor], rules: [String: Rule], bridgeConfiguration: BridgeConfiguration?) {
      
        self._lights = lights;
        self._groups = groups;
        self._schedules = schedules;
        self._scenes = scenes;
        self._sensors = sensors;
        self._rules = rules;
        self._bridgeConfiguration = bridgeConfiguration
    };
    
    public convenience init?(json: JSON) {
        
        self.init()

        guard
            let lightsJSON = json[HeartbeatBridgeResourceType.lights.rawValue] as? JSON,
            let groupsJSON = json[HeartbeatBridgeResourceType.groups.rawValue] as? JSON,
            let schedulesJSON = json[HeartbeatBridgeResourceType.schedules.rawValue] as? JSON,
            let scenesJSON = json[HeartbeatBridgeResourceType.scenes.rawValue] as? JSON,
            let sensorsJSON = json[HeartbeatBridgeResourceType.sensors.rawValue] as? JSON,
            let rulesJSON = json[HeartbeatBridgeResourceType.rules.rawValue] as? JSON
        else { return nil }

        let lightsDict = Light.dictionaryFromResourcesJSON(lightsJSON)
        let groupsDict = Group.dictionaryFromResourcesJSON(groupsJSON)
        let schedulesDict = Schedule.dictionaryFromResourcesJSON(schedulesJSON)
        let scenesDict = PartialScene.dictionaryFromResourcesJSON(scenesJSON)
        let sensorsDict = Sensor.dictionaryFromResourcesJSON(sensorsJSON)
        let rulesDict = Rule.dictionaryFromResourcesJSON(rulesJSON)

        self._lights = lightsDict
        self._groups = groupsDict
        self._schedules = schedulesDict
        self._scenes = scenesDict
        self._sensors = sensorsDict
        self._rules = rulesDict

        if let configJSON = json[HeartbeatBridgeResourceType.config.rawValue] as? JSON {
            _bridgeConfiguration = BridgeConfiguration(json: configJSON)
        }
        
    }
    
    public func toJSON() -> JSON? {
        var json: JSON = [
            HeartbeatBridgeResourceType.lights.rawValue: convertBridgeResourceDictToJSONDict(_lights),
            HeartbeatBridgeResourceType.groups.rawValue: convertBridgeResourceDictToJSONDict(_groups),
            HeartbeatBridgeResourceType.schedules.rawValue: convertBridgeResourceDictToJSONDict(_schedules),
            HeartbeatBridgeResourceType.scenes.rawValue: convertBridgeResourceDictToJSONDict(_scenes),
            HeartbeatBridgeResourceType.sensors.rawValue: convertBridgeResourceDictToJSONDict(_sensors),
            HeartbeatBridgeResourceType.rules.rawValue: convertBridgeResourceDictToJSONDict(_rules)
        ]
        if let bridgeConfigurationJSON = _bridgeConfiguration?.toJSON() {
            json[HeartbeatBridgeResourceType.config.rawValue] = bridgeConfigurationJSON
        }
        return json
    }
    
    public func convertBridgeResourceDictToJSONDict<T: BridgeResource>(_ dictToConvert: [String: T]) -> [String: JSON] {
        
        var dict: [String: JSON] = [:]
        for (key, bridgeResource) in dictToConvert {
            dict[key] = bridgeResource.toJSON()!
        }
        
        return dict
        
    }
    
    // MARK: Set
    
    internal func setLights(_ lights: [String: Light]) {
        _lights = lights
    }
    
    internal func setGroups(_ groups: [String: Group]) {
        _groups = groups
    }
    
    internal func setSchedules(_ schedules: [String: Schedule]) {
        _schedules = schedules
    }
    
    internal func setScenes(_ scenes: [String: PartialScene]) {
        _scenes = scenes
    }
    
    internal func setSensors(_ sensors: [String: Sensor]) {
        _sensors = sensors
    }
    
    internal func setRules(_ rules: [String: Rule]) {
        _rules = rules
    }
    
    internal func setBridgeConfiguration(_ bridgeConfiguration: BridgeConfiguration) {
        _bridgeConfiguration = bridgeConfiguration
    }
    
    // MARK: Update
    
    internal func updateLight(_ light: Light) {
        
        _lights[light.identifier] = light
    }
    internal func updateGroup(_ group: Group) {
        
        _groups[group.identifier] = group
    }
    internal func updateSchedule(_ schedule: Schedule) {
        
        _schedules[schedule.identifier] = schedule
    }
    internal func updateScene(_ scene: PartialScene) {
        
        _scenes[scene.identifier] = scene
    }
    internal func updateSensor(_ sensor: Sensor) {
        
        _sensors[sensor.identifier] = sensor
    }
    internal func updateRule(_ rule: Rule) {
        
        _rules[rule.identifier] = rule
    }
    internal func updateBridgeConfiguration(_ bridgeConfiguration: BridgeConfiguration) {
        
        _bridgeConfiguration = bridgeConfiguration
    }
}


//    public func toJSON() -> JSON? {
//
//        var dict: [String: JSON] = [:]
//
//        var lightsJSONDict: [String: JSON] = convertBridgeResourceDictToJSONDict(self._lights)
//        var groupsJSONDict: [String: JSON] = convertBridgeResourceDictToJSONDict(self._groups)
//        var schedulesJSONDict: [String: JSON] = convertBridgeResourceDictToJSONDict(self._schedules)
//        var scenesJSONDict: [String: JSON] = convertBridgeResourceDictToJSONDict(self._scenes)
//        var sensorsJSONDict: [String: JSON] = convertBridgeResourceDictToJSONDict(self._sensors)
//        var rulesJSONDict: [String: JSON] = convertBridgeResourceDictToJSONDict(self._rules)
//
//        dict[HeartbeatBridgeResourceType.Lights.rawValue] = lightsJSONDict;
//        dict[HeartbeatBridgeResourceType.Groups.rawValue] = groupsJSONDict;
//        dict[HeartbeatBridgeResourceType.Schedules.rawValue] = schedulesJSONDict;
//        dict[HeartbeatBridgeResourceType.Scenes.rawValue] = scenesJSONDict;
//        dict[HeartbeatBridgeResourceType.Sensors.rawValue] = sensorsJSONDict;
//        dict[HeartbeatBridgeResourceType.Rules.rawValue] = rulesJSONDict;
//
//        var bridgeConfigJSON = self.bridgeConfiguration?.toJSON()
//        if let bridgeConfigJSON = bridgeConfigJSON {
//            dict[HeartbeatBridgeResourceType.Config.rawValue] = bridgeConfigJSON
//        }
//
//        return dict
//    }
