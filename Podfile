# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TwitterClient' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TwitterClient
  pod 'AFNetworking'
  pod 'BDBOAuth1Manager'
  pod 'NSDateMinimalTimeAgo', '~> 0.1.0'
  pod 'FLEX', '~> 2.0', :configurations => ['Debug']
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.2'
      end
    end
  end

end
