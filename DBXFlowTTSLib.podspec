Pod::Spec.new do |s|
  s.name             = 'DBXFlowTTSLib'
  s.version          = '2.2.0'
  s.summary          = '语音合成'
  s.description      = <<-DESC
流式语音合成iOSSDK，此库依赖于DBCommonLib
                       DESC
  s.homepage         = 'https://github.com/data-baker/DBXFlowTTSLib'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '李明辉' => 'liminghui@data-baker.com' }
  s.source           = { :git => 'https://github.com/data-baker/DBXFlowTTSLib.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  # s.source_files = 'DBXFlowTTSLib/Classes/**/*'
  s.vendored_frameworks   = 'DBXFlowTTSLib/Classes/*.framework'
  s.dependency 'DBCommonLib'
end

