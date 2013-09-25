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
  spec.summary       = %q{Given an url, this gem picks out its source of origin and the minimal unique identifier based on its origin. }
  spec.homepage      = "http://www.github.com/settinghead/url_analyzer"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "2.14.1"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "domainatrix", "~> 0.0.11"
end
