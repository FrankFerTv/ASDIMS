platform :ios, '12.2'

target 'Inventory System Animal Services' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Inventory System Animal Services
    pod 'ChameleonFramework'
    pod 'SVProgressHUD'
    pod 'Firebase'
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'Firebase/Auth'
    pod 'Firestore', :podspec => 'https://storage.googleapis.com/firebase-preview-drop/ios/firestore/0.7.0/Firestore.podspec.json'
    
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
            end
        end
    end
    end

