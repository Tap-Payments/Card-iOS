Pod::Spec.new do |s|
  s.name             = 'Card-iOS'
  s.version          = '1.0.3'
  s.summary          = 'From the shelf card processing library provided by Tap Payments'
  s.homepage         = 'https://github.com/Tap-Payments/Card-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'o.rabie' => 'o.rabie@tap.company', 'h.sheshtawy' => 'h.sheshtawy@tap.company' }
  s.source           = { :git => 'https://github.com/Tap-Payments/Card-iOS.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.source_files = 'Sources/Card-iOS/Logic/**/*.swift'
  s.resources = "Sources/Card-iOS/Resources/**/*.{json,xib,pdf,png,gif,storyboard,xcassets,xcdatamodeld,lproj}"
  s.dependency'SwiftEntryKit'
  s.dependency'SwiftyRSA'
  s.dependency'SnapKit'
  s.dependency'SharedDataModels-iOS'
  s.dependency'TapCardScannerWebWrapper-iOS'
  s.dependency'TapFontKit-iOS'
  
  
end
