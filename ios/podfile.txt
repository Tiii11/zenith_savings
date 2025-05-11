# --- Standard Flutter Podfile ---
# This Podfile is a Ruby script that defines your iOS project's dependencies,
# managed by CocoaPods. Flutter uses it to integrate the Flutter engine and plugins.

#platform :ios, '11.0' # Flutter usually sets this during build based on your project settings
                      # It's often commented out by default in new projects as Flutter handles it.
                      # If you need to enforce a higher deployment target, you can uncomment and set it.
                      # Example: platform :ios, '12.0'


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
    target.build_configurations.each do |config|
      # You can add custom build settings here if needed.
      # For example, to enable bitcode:
      # config.build_settings['ENABLE_BITCODE'] = 'YES'
      #
      # To set a specific Swift version (usually not needed as Flutter handles it):
      # config.build_settings['SWIFT_VERSION'] = '5.0'

      # Example: Disable unused architecture warnings (can be noisy)
      # config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES' if config.name == 'Debug'
      # config.build_settings['VALID_ARCHS'] = 'arm64 armv7 x86_64' # Adjust if needed
    end
  end
end

target 'Runner' do
  # If you are using frameworks from CocoaPods, you may need to uncomment `use_frameworks!`
  # and add `source_h` for any headers you import in your Objective-Cbridging header.
  # See https://guides.cocoapods.org/syntax/podfile.html#use_frameworks_bang
  #
  # For Flutter, use_frameworks! is generally required if any of your plugins
  # are Swift-based or require dynamic frameworks. Flutter plugins typically handle this.
  use_frameworks!
  use_modular_headers! # Recommended for Swift and mixed-language pods

  # This is the crucial line that integrates Flutter and its plugins
  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))

  # You can add other native iOS pods here if your app needs them directly
  # and they are not part of a Flutter plugin.
  # Example:
  # pod 'Firebase/Analytics'
  # pod 'SomeOtherNativePod', '~> 1.0'
end

post_install do |installer|
  flutter_post_install(installer)

  # This script is used to prevent issues with duplicate symbol linker errors
  # when building for archive (release).
  # See: https://github.com/flutter/flutter/issues/106190
  # And: https://github.com/CocoaPods/CocoaPods/issues/11402
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # Flutter's default is to use -framework for linking, but some pods might need -l
      # This ensures that the linker flags are set up correctly.
      # It also addresses an issue where some pods might have their own `OTHER_LDFLAGS`
      # that could conflict or override Flutter's settings.
      # This specific part helps with symbol stripping for release builds.
      if config.name == 'Release'
        config.build_settings['SWIFT_COMPILATION_MODE'] = 'wholemodule'
        # You might see other common post_install scripts here from Flutter or plugins.
        # For example, a common one to disable multiple commands warning:
        # if target.name == ' برخی از_YOUR_TARGETS_HERE' # Replace with actual target name if needed
        #   config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        # end
      end
    end
  end
end