#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flan_darwin'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for sending notifications.'
  s.description      = 'A Flutter plugin for making iOS and MacOS send system notifications.'
  s.homepage         = 'https://github.com/arnath/flan'
  s.license          = { :type => 'BSD', :file => '../LICENSE' }
  s.author           = { 'Vijay Prakash' => 'me@vijayp.dev' }
  s.source           = { :http => 'https://github.com/arnath/flan' }
  s.documentation_url = 'https://pub.dev/packages/flan'
  s.source_files = 'flan_darwin/Sources/**/*.swift'
  s.xcconfig = {
      'LIBRARY_SEARCH_PATHS' => '$(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)/ $(SDKROOT)/usr/lib/swift',
      'LD_RUNPATH_SEARCH_PATHS' => '/usr/lib/swift',
  }
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end
