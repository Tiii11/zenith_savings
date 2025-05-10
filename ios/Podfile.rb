# Uncomment this line to define a global platform for your project
# platform :ios, '11.0' # Flutter usually sets this based on your project

# CocoaPods analytics sends network requests to Google Analytics to track usage.
# Usage data is stored in Google Analytics using data collection practices defined
# in Google's privacy policy: https://policies.google.com/privacy
ENV['COCOAPODS_ANALYTICS_DISABLED'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_post_install(installer)
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end
end

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  # This line is crucial: it tells CocoaPods to find and install
  # all the necessary pods for Flutter and its plugins.
  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end

post_install do |installer|
  flutter_post_install(installer)
  # Enable Swift static linking if a newer CocoaPods version is used.
  # installer.pods_project.targets.each do |target|
  #   target.build_configurations.each do |config|
  #     config.build_settings['SWIFT_VERSION'] = '5.0' # Or your Swift version
  #   end
  # end
end