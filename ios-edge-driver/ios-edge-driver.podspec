
Pod::Spec.new do |s|
  s.name         = "ios-edge-driver"
  s.version      = "1.0.0"
  s.summary      = "ios-edge-driver"
  s.description  = <<-DESC
                  Driver for handheld readers
                   DESC
  s.homepage     = "https://github.com/Xemelgo/ios-edge-driver"
  s.license      = "MIT"
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/Xemelgo/ios-edge-driver", :tag => "master" }
  s.source_files  = ["ios/*.{h,m,swift}", "ios/AsReaderDock/*.{h,m,swift}"]
  s.requires_arc = true
  
  s.vendored_frameworks = "ios/AsReaderDockSDK.framework"
  s.ios.framework = "ExternalAccessory"

  s.dependency "React"

end

  