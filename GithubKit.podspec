Pod::Spec.new do |s|
  s.platform = :ios
  s.ios.deployment_target = '11.0'
  s.name = "GithubKit"
  s.summary = "GithubKit for sample applications"
  s.requires_arc = true
  s.swift_version = '4.2'
  s.version = "0.4.1"
  s.license = 'MIT'
  s.author = { "Taiki Suzuki" => "s1180183@gmail.com" }
  s.homepage = "https://github.com/marty-suzuki/GithubKitForSample"
  s.source = { :git => "https://github.com/marty-suzuki/GithubKitForSample.git", :tag => "#{s.version}"}
  s.framework = "UIKit"
  s.source_files = "GithubKit/Sources/**/*.{swift}"
  s.resources = "GithubKit/Sources/**/*.{xib}"
  s.dependency 'SwiftIconFont', '~> 3.0'
  s.dependency 'Nuke', '~> 7.0'
end
