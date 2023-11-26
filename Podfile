# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'

# Ignore Warnings
inhibit_all_warnings!

target 'Uplift' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Uplift
  pod 'SwiftLint', :inhibit_warnings => false

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
   target.build_configurations.each do |config|
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
   end
  end
end