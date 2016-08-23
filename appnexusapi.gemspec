# -*- encoding: utf-8 -*-
require File.expand_path('../lib/appnexusapi/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Brandon Aaron"]
  gem.email         = ["brandon.aaron@gmail.com"]
  gem.description   = %q{}
  gem.summary       = %q{Unofficial Ruby API Wrapper for Appnexus}
  gem.homepage      = "http://simpli.fi"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "appnexusapi"
  gem.require_paths = ["lib"]
  gem.version       = AppnexusApi::VERSION

  gem.add_dependency 'faraday', '~> 0.9'
  gem.add_dependency 'faraday_middleware'
  gem.add_dependency 'multi_json'
  gem.add_dependency 'pester'
  gem.add_dependency 'null_logger'

  gem.add_development_dependency 'bundler', '>= 1.2.0'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'dotenv'
  gem.add_development_dependency 'pry'
end
