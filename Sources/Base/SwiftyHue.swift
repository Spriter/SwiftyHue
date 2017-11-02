//
//  SwiftyHue.swift
//  Pods
//
//  Created by Marcel Dittmann on 15.05.16.
//
//

import Foundation
import Log

public class SwiftyHue: NSObject {
    
    // MARK: Public Interface
    public var resourceCache: BridgeResourcesCache?;
    
    public var bridgeSendAPI: BridgeSendAPI = BridgeSendAPI()
    
    public var resourceAPI: ResourceAPI = ResourceAPI()
    
    public func setBridgeAccessConfig(_ bridgeAccessConfig: BridgeAccessConfig, resourceCacheHeartbeatProcessorDelegate: ResourceCacheHeartbeatProcessorDelegate? = nil) {
        
        self.bridgeAccessConfig = bridgeAccessConfig;
        self.resourceCacheHeartbeatProcessor = ResourceCacheHeartbeatProcessor(delegate: resourceCacheHeartbeatProcessorDelegate ?? self);
        self.bridgeSendAPI.setBridgeAccessConfig(bridgeAccessConfig)
        self.resourceAPI.setBridgeAccessConfig(bridgeAccessConfig)
        self.heartbeatManager = HeartbeatManager(bridgeAccesssConfig: bridgeAccessConfig, heartbeatProcessors: [resourceCacheHeartbeatProcessor!]);
    }
    
    public func setLocalHeartbeatInterval(_ interval: TimeInterval, forResourceType resourceType: HeartbeatBridgeResourceType) {
        
        heartbeatManager?.setLocalHeartbeatInterval(interval, forResourceType: resourceType)
    }
    
    public func removeLocalHeartbeat(forResourceType resourceType: HeartbeatBridgeResourceType) {
        
        heartbeatManager?.removeLocalHeartbeat(forResourceType: resourceType)
    }
    
    public func startHeartbeat() {
        
        heartbeatManager?.startHeartbeat()
    }
    
    public func stopHeartbeat() {
        
        heartbeatManager?.stopHeartbeat()
    }
    
    // MARK: Logging
    
    public func enableLogging(_ enabled: Bool) {
        Log.enabled = enabled
    }
    
    /**
     The minimum level of severity for the Logger.
     */
    public func setMinLevelForLogMessages(_ level: Level) {
        
        Log.minLevel = level
    }
    
    // MARK: Private
    private var bridgeAccessConfig: BridgeAccessConfig?;
    private var heartbeatManager: HeartbeatManager?;
    private var resourceCacheHeartbeatProcessor: ResourceCacheHeartbeatProcessor?;

    public override init() {
        super.init()
        enableLogging(false)
    }
}

extension SwiftyHue: ResourceCacheHeartbeatProcessorDelegate {
    
    public func resourceCacheUpdated(_ resourceCache: BridgeResourcesCache) {
                
        self.resourceCache = resourceCache;
    }
}
