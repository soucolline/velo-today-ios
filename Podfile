source 'https://cdn.cocoapods.org/'
platform :ios, '13.0'

inhibit_all_warnings!

target 'velib-map' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for velib-map
  pod 'SVProgressHUD', '= 2.2.5'
  pod 'SwiftLint', '= 0.45.1'
  pod 'ZLogger', '= 1.1.0'
  pod 'Swinject', '= 2.8.1'
  pod 'Bugsnag'
end

target 'velib-mapTests' do
  use_frameworks!
  pod 'Cuckoo', '= 1.5.2'
end

plugin 'cocoapods-keys', {
  :project => "velib-map",
  :keys => [
  "BugsnagApiKey"
]}

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      end
    end
end
