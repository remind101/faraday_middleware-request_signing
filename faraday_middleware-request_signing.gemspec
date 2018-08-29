# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'faraday_middleware/request_signing/version'

Gem::Specification.new do |spec|
  spec.name          = "faraday_middleware-request_signing"
  spec.version       = FaradayMiddleware::RequestSigning::VERSION
  spec.authors       = ["Vlad Yarotsky"]
  spec.email         = ["vlad@remind101.com"]

  spec.summary       = %q{Request signing middleware}
  spec.description   = %q{Request signing middleware that implements a portion of https://tools.ietf.org/html/draft-cavage-http-signatures-07}
  spec.homepage      = "https://github.com/remind101/faraday_middleware-request_signin"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "http://gems.remind.com"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 0.15.0"
  spec.add_dependency "http_signatures", "~> 1.0"

  spec.add_development_dependency "rack-test", "~> 0.6"
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
