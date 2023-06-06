
Pod::Spec.new do |s|
  s.name         = "ios-edge-driver"
  s.version      = "1.0.0"
  s.summary      = "ios-edge-driver"
  s.description  = <<-DESC
                  Driver for handheld readers
                   DESC
  s.homepage     = "https://github.com"
  s.license      = "MIT"
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com", :tag => "master" }
  s.source_files  = [
    "ios/*.{h,m,swift}",
    "ios/AsReaderDock/*.{h,m,swift}",
    "ios/AsReaderGun/*.{h,m,swift}",
    "ios/Utils/*.swift"
  ]
  s.requires_arc = true
  
  s.vendored_frameworks = [
    "ios/AsReaderDock/AsReaderDockSDK.framework",
    "ios/AsReaderGun/AsReaderGunSDK.framework",
    "ios/AsReaderGun/AsRingAccessorySDK.framework",
  ]
  s.ios.framework = "ExternalAccessory"

  s.dependency "React"

end

  