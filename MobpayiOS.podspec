Pod::Spec.new do |spec|
spec.name         = "MobpayiOS"
spec.version      = "0.1.5"
spec.summary      = "MobpayiOS - An iOS library for integrating card and mobile payments through Interswitch"
# spec.description  = <<-DESC
#  This SDK library enables you to integrate Interswitch payments to your mobile app
#  DESC

spec.homepage     = "https://www.interswitchgroup.com/ke/"
spec.license      = "MIT"
spec.author       = { "Allan Mageto" => "alan.mageto@interswitchgroup.com" }
spec.source       = { :git => "https://github.com/interswitch-kenya-limited/mobpay-ios-lib.git", :tag => spec.version}
spec.source_files  = "mobpay-ios/*.swift"
spec.resources = "mobpay-ios/*.xcassets"

# spec.exclude_files = "Classes/Exclude"
spec.platform     = :ios, "10.0"
spec.exclude_files = "Classes/Exclude"
spec.swift_version = '5.0'
spec.dependency 'CryptoSwift', '~> 1.0'
spec.dependency 'SwiftyRSA', '~> 1.5'
spec.dependency 'PercentEncoder', '~> 1.2'
spec.dependency 'Eureka', '~> 5.0.0'
spec.dependency 'CocoaMQTT', '~> 1.2'
spec.dependency 'CreditCardRow', '~> 3.2'

end
