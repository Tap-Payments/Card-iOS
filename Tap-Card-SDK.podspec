Pod::Spec.new do |s|
  s.name             = 'SharedDataModels-iOS'
  s.version          = '0.0.10'
  s.summary          = 'Common data models for used across different Tap sdks SharedDataModels-iOS.'
  s.homepage         = 'https://github.com/Tap-Payments/SharedDataModels-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'o.rabie' => 'o.rabie@tap.company', 'h.sheshtawy' => 'h.sheshtawy@tap.company' }
  s.source           = { :git => 'https://github.com/Tap-Payments/SharedDataModels-iOS.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.source_files = 'Sources/SharedDataModels-iOS/**/*'
end
