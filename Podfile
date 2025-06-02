# Uncomment the next line to define a global platform for your project
# platform :ios, '10.0'

target 'Healf-healthFreinds' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Healf-healthFreinds
pod 'NMapsMap'
pod 'SnapKit', '~> 5.7.0'
pod 'Then'
pod 'Cosmos', '~> 23.0'
pod 'FirebaseAuth'
pod 'FirebaseAnalytics'
pod 'FirebaseFirestore'
pod 'FirebaseStorage'
pod 'FirebaseMessaging'
pod 'MessageKit'
pod 'Firebase/Database'
pod 'ObjectMapper'
pod 'FSCalendar'
pod 'FloatingPanel'
pod 'RxSwift'
pod 'RxCocoa'
pod 'Kingfisher', '~> 7.0'
pod 'KakaoSDKUser'
pod 'KakaoSDKAuth'
pod 'Alamofire'
pod 'DropDown'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'BoringSSL-GRPC'
      target.source_build_phase.files.each do |file|
        if file.settings && file.settings['COMPILER_FLAGS']
          flags = file.settings['COMPILER_FLAGS'].split
          flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
          file.settings['COMPILER_FLAGS'] = flags.join(' ')
        end
      end
    end
  end
end
end
