#
# Be sure to run `pod lib lint BGMemoryLeaks.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BGMemoryLeaks'
  s.version          = '0.1.0'
  s.summary          = 'A short description of BGMemoryLeaks.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  一款用于自动检测项目中基于控制器引用链，内存泄漏检测的利器，支持 ObjC，Swift。
                       DESC

  s.homepage         = 'https://github.com/bingoxu/BGMemoryLeaks'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'bingoxu' => 'bingoxu@yeahka.com' }
  s.source           = { :git => 'https://github.com/bingoxu/BGMemoryLeaks.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'BGMemoryLeaks/Classes/**/*'
  
  s.subspec 'Core' do |core|
      core.source_files = 'BGMemoryLeaks/Classes/Core/*.{h,m}'
  end
  
  # s.resource_bundles = {
  #   'BGMemoryLeaks' => ['BGMemoryLeaks/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
