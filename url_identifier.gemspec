# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'url_analyzer/version'

Gem::Specification.new do |spec|
  spec.name          = "url_analyzer"
  spec.version       = UrlAnalyzer::VERSION
  spec.authors       = ["Xiyang Chen"]
  spec.email         = ["settinghead@gmail.com"]
  spec.description   = %q{Retrieve unique identifier information from common websites, such as YouTube, Blogspot, etc.}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
