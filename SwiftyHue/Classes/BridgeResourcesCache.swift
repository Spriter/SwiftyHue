//
//  BridgeResourcesCache.swift
//  Pods
//
//  Created by Marcel Dittmann on 23.04.16.
//
//

import Foundation
import Gloss

public class BridgeResourcesCache {
    
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
    
    private var _lights: [String: Light];
    private var _groups: [String: Group];
    private var _schedules: [String: Schedule];
    private var _scenes: [String: PartialScene];
    private var _sensors: [String: Sensor];
    private var _rules: [String: Rule];
    private var _bridgeConfiguration: BridgeConfiguration?;
    
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
    
    internal func setLights(lights: [String: Light]) {
        self._lights = lights
    }
    
    internal func setGroups(groups: [String: Group]) {
        self._groups = groups
    }
    
    internal func setSchedules(schedules: [String: Schedule]) {
        self._schedules = schedules
    }
    
    internal func setScenes(scenes: [String: PartialScene]) {
        self._scenes = scenes
    }
    
    internal func setSensors(sensors: [String: Sensor]) {
        self._sensors = sensors
    }
    
    internal func setRules(rules: [String: Rule]) {
        self._rules = rules
    }
    
    internal func setBridgeConfiguration(bridgeConfiguration: BridgeConfiguration) {
        self._bridgeConfiguration = bridgeConfiguration
    }
}