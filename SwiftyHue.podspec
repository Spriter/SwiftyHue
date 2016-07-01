#
# Be sure to run `pod lib lint SwiftyHue.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SwiftyHue"
  s.version          = "0.1.17"
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
s.source           = { :git => "https://github.com/Spriter/SwiftyHue.git", :tag => "v0.1.17" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'

  s.pod_target_xcconfig = { 'ENABLE_TESTABILITY[config=Debug]' => 'YES' }
  s.source_files = 'Sources/SwiftyHue.h'

  #s.resource_bundles = {
   # 'SwiftyHue' => ['SwiftyHue/Assets/*.png']
  #}

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  s.subspec 'Base' do |base|

    base.ios.deployment_target = '8.0'
    base.tvos.deployment_target = '9.0'
    base.watchos.deployment_target = '2.2'

    base.source_files = 'Sources/Base/**/*.{h,swift}'
    base.dependency 'Alamofire', '~> 3.4.0'
    base.dependency 'Gloss', '~> 0.7'
    base.dependency 'Log', '~> 0.5'

  end

  s.subspec 'BridgeServices' do |bridgeservices|
    bridgeservices.source_files   = 'Sources/BridgeServices/**/*.{h,swift}'

    bridgeservices.ios.deployment_target = '8.0'
    bridgeservices.tvos.deployment_target = '9.0'

    bridgeservices.dependency 'Alamofire', '~> 3.4.0'
    bridgeservices.dependency 'Gloss', '~> 0.7'
    bridgeservices.dependency 'CocoaAsyncSocket', '~> 7.4.3'
    bridgeservices.dependency 'Log', '~> 0.5'

  end

end
