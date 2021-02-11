Pod::Spec.new do |s|
  last_commit = `git rev-list --tags --max-count=1`.strip
  last_tag = `git describe --tags #{last_commit}`.strip

  s.platform = :ios
  s.ios.deployment_target = '13.0'
  s.name = "GithubKit"
  s.summary = "GithubKit for sample applications"
  s.requires_arc = true
  s.swift_version = '5'
  s.version = last_tag
  s.license = 'MIT'
  s.author = { "Taiki Suzuki" => "s1180183@gmail.com" }
  s.homepage = "https://github.com/marty-suzuki/GithubKitForSample"
  s.source = { :git => "https://github.com/marty-suzuki/GithubKitForSample.git", :tag => "#{s.version}"}
  s.framework = "UIKit"
  s.source_files = "GithubKit/Sources/**/*.{swift}"
end
