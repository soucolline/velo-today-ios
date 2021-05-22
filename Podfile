source 'https://cdn.cocoapods.org/'
platform :ios, '13.0'

inhibit_all_warnings!

target 'velib-map' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for velib-map
  pod 'SVProgressHUD', '= 2.2.5'
  pod 'SwiftLint', '= 0.43.1'
  pod 'ZLogger', '= 1.1.0'
  pod 'Swinject', '= 2.7.1'
  pod 'Bugsnag'
end

target 'velib-mapTests' do
  use_frameworks!
  pod 'Cuckoo', '= 1.5.0'
end

plugin 'cocoapods-keys', {
  :project => "velib-map",
  :keys => [
  "BugsnagApiKey"
]}
