//
//  SwiftyHue.swift
//  Pods
//
//  Created by Marcel Dittmann on 15.05.16.
//
//

import Foundation
import SwiftyHue


public class SwiftyHue {
    
    // MARK: Public Interface
    public var resourceCache: BridgeResourcesCache?;
    
    public var bridgeSendAPI: BridgeSendAPI = BridgeSendAPI();
    
    public func setBridgeAccessConfig(bridgeAccessConfig: BridgeAccessConfig) {
        
        self.bridgeAccessConfig = bridgeAccessConfig;
        self.resourceCacheHeartbeatProcessor = ResourceCacheHeartbeatProcessor(delegate: self);
        self.bridgeSendAPI.setBridgeAccessConfig(bridgeAccessConfig)
        self.heartbeatManager = HeartbeatManager(bridgeAccesssConfig: bridgeAccessConfig, heartbeatProcessors: [resourceCacheHeartbeatProcessor!]);
    }
    
    public func setLocalHeartbeatInterval(interval: NSTimeInterval, forResourceType resourceType: BridgeResourceType) {
        
        heartbeatManager?.setLocalHeartbeatInterval(interval, forResourceType: resourceType)
    }
    
    public func startHeartbeat() {
        
        heartbeatManager?.startHeartbeat()
    }
    
    public func stopHeartbeat() {
        
        heartbeatManager?.stopHeartbeat()
    }
    
    public func enableLogging(enabled: Bool) {
        Log.enabled = enabled
    }
    
    // MARK: Private
    private var bridgeAccessConfig: BridgeAccessConfig?;
    private var heartbeatManager: HeartbeatManager?;
    private var resourceCacheHeartbeatProcessor: ResourceCacheHeartbeatProcessor?;

    public init() {
        
    }
}

extension SwiftyHue: ResourceCacheHeartbeatProcessorDelegate {
    
    func resourceCacheUpdated(resourceCache: BridgeResourcesCache) {
                
        self.resourceCache = resourceCache;
    }
}