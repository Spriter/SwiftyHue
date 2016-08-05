//
//  SwiftyHue.swift
//  Pods
//
//  Created by Marcel Dittmann on 15.05.16.
//
//

import Foundation
import Log

public class SwiftyHue {
    
    // MARK: Public Interface
    public var resourceCache: BridgeResourcesCache?;
    
    public var bridgeSendAPI: BridgeSendAPI = BridgeSendAPI();
    
    public func setBridgeAccessConfig(_ bridgeAccessConfig: BridgeAccessConfig) {
        
        self.bridgeAccessConfig = bridgeAccessConfig;
        self.resourceCacheHeartbeatProcessor = ResourceCacheHeartbeatProcessor(delegate: self);
        self.bridgeSendAPI.setBridgeAccessConfig(bridgeAccessConfig)
        self.heartbeatManager = HeartbeatManager(bridgeAccesssConfig: bridgeAccessConfig, heartbeatProcessors: [resourceCacheHeartbeatProcessor!]);
    }
    
    public func setLocalHeartbeatInterval(_ interval: TimeInterval, forResourceType resourceType: HeartbeatBridgeResourceType) {
        
        heartbeatManager?.setLocalHeartbeatInterval(interval, forResourceType: resourceType)
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

    public init() {

        enableLogging(false)
    }
}

extension SwiftyHue: ResourceCacheHeartbeatProcessorDelegate {
    
    func resourceCacheUpdated(_ resourceCache: BridgeResourcesCache) {
                
        self.resourceCache = resourceCache;
    }
}
