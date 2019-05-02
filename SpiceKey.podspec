Pod::Spec.new do |spec|
  spec.name         = "SpiceKey"
  spec.version      = "1.3"
  spec.summary      = "Global Shortcuts for macOS written in Swift."
  spec.description  = <<-DESC
    By using SpiceKey, you can implement an utility app with shortcuts easily.
    Demo app can be downloaded from GitHub.
  DESC
  spec.homepage     = "https://github.com/Kyome22/SpiceKey"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Takuto Nakamura" => "kyomesuke@icloud.com" }
  spec.social_media_url   = "https://twitter.com/Kyomesuke3"
  spec.osx.deployment_target = '10.12'
  spec.source       = { :git => "https://github.com/Kyome22/SpiceKey.git", :tag => "#{spec.version}" }
  spec.frameworks = 'Appkit', 'Carbon'
  spec.source_files  = "SpiceKey/**/*.swift"
  spec.swift_version = "5"
  spec.requires_arc = true
end
