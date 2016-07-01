//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

protocol SensorConfigProvider {
    associatedtype SensorConfigType: SensorConfig
    
    var config: SensorConfigType {get}
}

protocol SensorStateProvider {
    associatedtype SensorStateType: SensorState
    
    var state: SensorStateType {get}
}

func ==(lhs: GenericFlagSensor, rhs: GenericFlagSensor) -> Bool {
    return lhs.id != rhs.id
}

protocol Sensor {
    
    var id: String {get}
    var name: String {get}
    
}

protocol SensorConfig {
    
}

protocol SensorState {
    
}

class GenericFlagSensor: Sensor, SensorConfigProvider, SensorStateProvider, Equatable {
    
    typealias SensorConfigType = GenericFlagSensorConfig
    typealias SensorStateType = GenericFlagSensorState
    
    var id: String
    var name: String
    var config: GenericFlagSensorConfig
    var state: GenericFlagSensorState
    
    init() {
        
        id = ""
        name = ""
        config = GenericFlagSensorConfig()
        state = GenericFlagSensorState()
        
    }
}



class GenericFlagSensorConfig: SensorConfig {
    
    init(){}
}

class GenericFlagSensorState: SensorState {
    
    init(){}
    
}

// TestCode

var mySensors: GenericFlagSensor = GenericFlagSensor()

var nsdict: NSDictionary = ["1": mySensors]

var dict: [String: GenericFlagSensor] = ["1": mySensors]

print((nsdict as! [String: GenericFlagSensor]) == dict)
