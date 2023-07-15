Pod::Spec.new do |s|
  s.name             = 'SDKHttpCore'
  s.version          = '0.1.0-rc.1'
  s.summary          = 'A short description of SDKHttpCore.'
  s.homepage         = 'https://github.com/raulmax319/SDKHttpCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Raul Max' => 'github.com/raulmax319' }
  s.source           = { :http => 'https://github.com/raulmax319/sdk-http-core/raw/feat/xcframework/SDKHttpCore.xcframework.zip' }
  s.ios.deployment_target = '12.0'
  s.default_subspec = 'Release'

  s.subspec 'Debug' do |sd|
    sd.source_files = 'Sources/SDKHttpCore/Lib/**/*'

    sd.test_spec 'Tests' do |ts|
      ts.source_files = 'Sources/SDKHttpCore/Tests/**/*'
    end
  end

  s.subspec 'Release' do |sr|
    sr.vendored_frameworks = 'SDKHttpCore.xcframework'
  end
end
