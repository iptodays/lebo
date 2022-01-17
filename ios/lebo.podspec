#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint lebo.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'lebo'
  s.version          = '0.0.1'
  s.summary          = 'lebo sdk'
  s.description      = <<-DESC
lebo sdk
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'LBLelinkKit', '30706'
  s.ios.vendored_frameworks = 'LBLelinkKit/LBLelinkKit.framework'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
