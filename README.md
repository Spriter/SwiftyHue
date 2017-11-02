<p align="left">
    <a href="https://github.com/Carthage/Carthage"><img alt="Carthage compatible" src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"/></a>
    <a href="https://img.shields.io/cocoapods/v/SwiftyHue.svg"><img alt="CocoaPods compatible" src="https://img.shields.io/cocoapods/v/SwiftyHue.svg"/></a>
    <a href="https://img.shields.io/cocoapods/p/SwiftyHue.svg"><img alt="Platform" src="https://img.shields.io/cocoapods/p/SwiftyHue.svg"/></a>
</p>

# SwiftyHue
Philips Hue SDK written in swift

Work in progress...

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

To integrate SwiftyHue into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Spriter/SwiftyHue"
```

### CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:
```bash
$ gem install cocoapods
```

To integrate SwiftyHue into your Xcode project using CocoaPods, specify it in your `Podfile`:
```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

pod 'SwiftyHue', '~> 0.1.2'
```

Then, run the following command:

```bash
$ pod install
```

#### Example with submodules

**SwiftyHue/Base:** The core functionality of SwiftyHue.

**SwiftyHue/BridgeServices:** Provides classes to find bridges in a network and authenticate with them.

```ruby
target 'MyApp' do
  use_frameworks!

  pod ’SwiftyHue’, '~> 0.1.6'

end

target 'MyApp tvOS' do
    use_frameworks!
    
    pod ’SwiftyHue’, '~> 0.1.6'
    
end

target 'MyApp watchOS Extension' do
    use_frameworks!
    
    pod ’SwiftyHue/Base’, '~> 0.1.6'
    
end
```
Note: You can use SwiftyHue/Base submodule to use SwiftyHue also on watchOS.

## Usage

### Find Bridge

The first step is to find a bridge in the network.

```swift
let bridgeFinder = BridgeFinder()
bridgeFinder.delegate = self;
bridgeFinder.start()
```

Implement the BridgeFinderDelegate protocol to get the search results.

```swift
extension BridgeSelectionTableViewController: BridgeFinderDelegate {
    
    func bridgeFinder(finder: BridgeFinder, didFinishWithResult bridges: [HueBridge]) {
     
        let bridges = bridges;
    }
}
```

### Bridge Authenticator

Before you can connect to a bridge you need to create user.

```swift
var bridgeAuthenticator: BridgeAuthenticator! = BridgeAuthenticator(bridge: bridge, uniqueIdentifier: "swiftyhue#\(UIDevice.currentDevice().name)")
```

Implement the BridgeAuthenticatorDelegate protocol to get the authentication events.

```swift
extension BridgePushLinkViewController: BridgeAuthenticatorDelegate {
    
    func bridgeAuthenticator(authenticator: BridgeAuthenticator, didFinishAuthentication username: String) {
        
    }
    
    func bridgeAuthenticator(authenticator: BridgeAuthenticator, didFailWithError error: NSError) {
     
    }
    
    // you should now ask the user to press the link button
    func bridgeAuthenticatorRequiresLinkButtonPress(authenticator: BridgeAuthenticator) {

    }
    
    // user did not press the link button in time, you restart the process and try again
    func bridgeAuthenticatorDidTimeout(authenticator: BridgeAuthenticator) {
        
    }
}
```

### Heartbeat

Setup Heartbeat for resource updates.

```Swift
    
let bridgeAccessConfig= BridgeAccessConfig(bridgeId: "YOUR_BRIDGE_ID", ipAddress: "YOUR_BRIDGE_IP", username: "YOUR_BRIDGE_USERNAME")
let swiftyHue: SwiftyHue = SwiftyHue();

swiftyHue.setBridgeAccessConfig(bridgeAccessConfig)
swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .Lights)
swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .Groups)
swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .Rules)
swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .Scenes)
swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .Schedules)
swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .Sensors)
swiftyHue.setLocalHeartbeatInterval(10, forResourceType: .Config)

swiftyHue.startHeartbeat()
```

Register for Update Events.

```Swift
NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.lightChanged), name: ResourceCacheUpdateNotification.LightsUpdated.rawValue, object: nil)
```

Use the resource cache.
```Swift
if let cache = swiftyHue.resourceCache {
    
    // Dict of lights [String: Light]. Keys are the light identifiers.
    let lights = cache.lights
}
```
### Send API

You can use the SendAPI to send requests to the bridge. For example recall a Scene or create a group.


```Swift
let sendAPI = swiftyHue.brideSendAPI
```
More coming soon...

### Resource API

You can use the resourceAPI to request resources from the bridge. For example all groups.


```Swift
let resourceAPI = swiftyHue.resourceAPI

resourceAPI.fetchGroups { (result) in

    guard let groups = result.value else {
        //...
        return
    }
    
    //...
}
```

## Generate documentation

Install jazzy:

    $ [sudo] gem install jazzy

Run generate script:

    $ ./generate_doc.sh

## Log
We use ['Log'](https://github.com/delba/Log) for Logging. Log` is a powerful logging framework that provides built-in themes and formatters, and a nice API to define your owns.
> Get the most out of `Log` by installing [`XcodeColors`](https://github.com/robbiehanson/XcodeColors) and [`KZLinkedConsole`](https://github.com/krzysztofzablocki/KZLinkedConsole)

## Contributing
We'd love to see your ideas for improving this repo! The best way to contribute is by submitting a pull request. We'll do our best to respond to your patch as soon as possible. You can also submit a issue if you find bugs. :octocat:

Please make sure to follow our general coding style and add test coverage for new features!

### Needs
You need [Carthage](https://github.com/Carthage/Carthage) to work on the SwiftyHue Project.
If you have Carthage installed just run
```bash
$ carthage bootstrap
```
in the root directory of the project. 
Remember to build the SwiftyHue framework targets to run the example application targets.

## Made with SwiftyHue
[Bridge Inspector](https://appsto.re/de/JvJodb.i)
