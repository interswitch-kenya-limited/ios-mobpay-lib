Pod::Spec.new do |spec|
  spec.name         = "mobpay"
  spec.version      = "0.0.1"
  spec.summary      = "Mobpay is a payment lib"
  spec.description  = <<-DESC
  longer description
                   DESC

  spec.homepage     = "http://EXAMPLE/mobpay"
  spec.license      = "MIT"
  spec.author             = { "Allan Mageto" => "allanbmageto@gmail.com" }
  spec.source       = { :git => "https://github.com/interswitch-kenya-limited/mobpay-ios-lib.git"}
  spec.source_files  = "mobpay-ios/*.swift"
 # spec.exclude_files = "Classes/Exclude"
  spec.platform     = :ios, "10.0"
  spec.exclude_files = "Classes/Exclude"
  spec.swift_version = '5.0'
  spec.dependency 'CryptoSwift', '~> 1.0'
  spec.dependency 'SwiftyRSA', '~> 1.5'
  spec.dependency 'PercentEncoder', '~> 1.2'

  
end
