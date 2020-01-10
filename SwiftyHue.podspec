#
# Be sure to run `pod lib lint SwiftyHue.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SwiftyHue"
  s.version          = "0.5.9"
  s.summary          = "Philips Hue SDK written in swift."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = "Philips Hue SDK written in swift. Work in progress."

  s.homepage         = "https://github.com/Spriter/SwiftyHue.git"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.authors          = { "Marcel Dittmann" => "marceldittmann@gmx.de", "Jerome Schmitz" => "jerome.schmitz@gmx.net", "Nils Lattek" => "nilslattek@gmail.com" }
  s.source           = { :git => "https://github.com/Spriter/SwiftyHue.git", :tag => "0.5.9" }

  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'

  s.pod_target_xcconfig = { 'ENABLE_TESTABILITY[config=Debug]' => 'YES' }
  s.source_files = 'Sources/SwiftyHue.h'

  s.swift_version = '5.0'

  s.subspec 'Base' do |base|

    base.ios.deployment_target = '9.0'
    base.tvos.deployment_target = '9.0'
    base.watchos.deployment_target = '2.2'
    base.osx.deployment_target = '10.11'

    base.source_files = 'Sources/Base/**/*.{h,swift}'
    base.dependency 'Alamofire', '4.8.0'
    base.dependency 'Gloss', '3.1.0'
  end

  s.subspec 'BridgeServices' do |bridgeservices|
    bridgeservices.source_files   = 'Sources/BridgeServices/**/*.{h,swift}'

    bridgeservices.ios.deployment_target = '9.0'
    bridgeservices.tvos.deployment_target = '9.0'
    bridgeservices.osx.deployment_target = '10.11'

    bridgeservices.dependency 'Alamofire', '4.8.0'
    bridgeservices.dependency 'Gloss', '3.1.0'
    bridgeservices.dependency 'CocoaAsyncSocket', '7.6.3'

  end

end
