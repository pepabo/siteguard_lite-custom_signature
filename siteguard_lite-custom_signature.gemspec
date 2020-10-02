
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "siteguard_lite/custom_signature/version"

Gem::Specification.new do |spec|
  spec.name          = "siteguard_lite-custom_signature"
  spec.version       = SiteguardLite::CustomSignature::VERSION
  spec.authors       = ["Takatoshi Ono"]
  spec.email         = ["takatoshi.ono@gmail.com"]

  spec.summary       = %q{This library load and dump SiteGuard Lite custom signature file.}
  spec.description   = %q{This library load and dump SiteGuard Lite custom signature file.}
  spec.homepage      = "https://github.com/pepabo/siteguard_lite-custom_signature"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel"
  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
