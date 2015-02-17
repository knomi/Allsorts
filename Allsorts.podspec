Pod::Spec.new do |spec|
  spec.name         = "Allsorts"
  spec.version      = "0.0.3"
  spec.summary      = "Algorithms on sorted collections and comparable types in Swift."
  spec.homepage     = "https://bitbucket.org/pyrtsa/Allsorts"

  spec.license      = "All rights reserved"

  spec.author       = { "Pyry Jahkola" => "pyry.jahkola@iki.fi" }
  spec.social_media_url = "https://twitter.com/pyrtsa"

  spec.source       = { :git => "git@bitbucket.org:pyrtsa/allsorts.git", :tag => "v#{spec.version}" }
  spec.source_files = "Allsorts/**/*.swift"

  spec.requires_arc = true

  spec.ios.deployment_target = "8.0"
  spec.osx.deployment_target = "10.10"
end
