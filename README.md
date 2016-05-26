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

Coming soon ...

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

