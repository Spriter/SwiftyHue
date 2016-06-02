//
//  BridgeResourcesCache.swift
//  Pods
//
//  Created by Marcel Dittmann on 23.04.16.
//
//

import Foundation
import Gloss

public class BridgeResourcesCache: Encodable, Decodable {
    
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
    
    required public convenience init?(json: JSON) {
        
        self.init()
                
        guard let lightsDict: [String: Light] = HeartbeatBridgeResourceType.lights.rawValue <~~ json,
            groupsDict: [String: Group] = HeartbeatBridgeResourceType.groups.rawValue <~~ json,
            schedulesDict: [String: Schedule] = HeartbeatBridgeResourceType.schedules.rawValue <~~ json,
            scenesDict: [String: PartialScene] = HeartbeatBridgeResourceType.scenes.rawValue <~~ json,
            sensorsDict: [String: Sensor] = HeartbeatBridgeResourceType.sensors.rawValue <~~ json,
            rulesDict: [String: Rule] = HeartbeatBridgeResourceType.rules.rawValue <~~ json
            
            else { return nil }
        
        self._lights = lightsDict
        self._groups = groupsDict
        self._schedules = schedulesDict
        self._scenes = scenesDict
        self._sensors = sensorsDict
        self._rules = rulesDict
        
        _bridgeConfiguration = HeartbeatBridgeResourceType.config.rawValue <~~ json
        
    }
    
    public func toJSON() -> JSON? {
        
        var json = jsonify([
            HeartbeatBridgeResourceType.lights.rawValue ~~> _lights,
            HeartbeatBridgeResourceType.groups.rawValue ~~> _groups,
            HeartbeatBridgeResourceType.schedules.rawValue ~~> _schedules,
            HeartbeatBridgeResourceType.scenes.rawValue ~~> _scenes,
            HeartbeatBridgeResourceType.sensors.rawValue ~~> _sensors,
            HeartbeatBridgeResourceType.rules.rawValue ~~> _rules,
            HeartbeatBridgeResourceType.config.rawValue ~~> _bridgeConfiguration
            ])
        
        print(json)
        
        return json
        
    }
    
    public func convertBridgeResourceDictToJSONDict(dictToConvert: [String: BridgeResource]) -> [String: JSON] {
        
        var dict: [String: JSON] = [:]
        for (key, bridgeResource) in dictToConvert {
            dict[key] = bridgeResource.toJSON()!
        }
        
        return dict
        
    }
    
    // MARK: Set
    
    internal func setLights(lights: [String: Light]) {
        _lights = lights
    }
    
    internal func setGroups(groups: [String: Group]) {
        _groups = groups
    }
    
    internal func setSchedules(schedules: [String: Schedule]) {
        _schedules = schedules
    }
    
    internal func setScenes(scenes: [String: PartialScene]) {
        _scenes = scenes
    }
    
    internal func setSensors(sensors: [String: Sensor]) {
        _sensors = sensors
    }
    
    internal func setRules(rules: [String: Rule]) {
        _rules = rules
    }
    
    internal func setBridgeConfiguration(bridgeConfiguration: BridgeConfiguration) {
        _bridgeConfiguration = bridgeConfiguration
    }
    
    // MARK: Update
    
    internal func updateLight(light: Light) {
        
        _lights[light.identifier] = light
    }
    internal func updateGroup(group: Group) {
        
        _groups[group.identifier] = group
    }
    internal func updateSchedule(schedule: Schedule) {
        
        _schedules[schedule.identifier] = schedule
    }
    internal func updateScene(scene: PartialScene) {
        
        _scenes[scene.identifier] = scene
    }
    internal func updateSensor(sensor: Sensor) {
        
        _sensors[sensor.identifier] = sensor
    }
    internal func updateRule(rule: Rule) {
        
        _rules[rule.identifier] = rule
    }
    internal func updateBridgeConfiguration(bridgeConfiguration: BridgeConfiguration) {
        
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