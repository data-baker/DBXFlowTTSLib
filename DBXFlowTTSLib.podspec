Pod::Spec.new do |s|
  s.name             = 'DBXFlowTTSLib'
  s.version          = '2.2.5'
  s.summary          = '语音合成'
  s.description      = <<-DESC
流式语音合成iOSSDK，此库依赖于DBCommonLib
                       DESC
  s.homepage         = 'https://github.com/data-baker/DBXFlowTTSLib'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'linxi' => 'linxi@data-baker.com' }
  s.source           = { :git => 'https://github.com/data-baker/DBXFlowTTSLib.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  # s.source_files = 'DBXFlowTTSLib/Classes/**/*'
  s.vendored_frameworks   = 'DBXFlowTTSLib/Classes/*.framework'
  s.dependency 'DBCommonLib','~>2.2.5'
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end

