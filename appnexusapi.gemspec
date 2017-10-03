# -*- encoding: utf-8 -*-
require File.expand_path('../lib/appnexusapi/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Marlon Moyer", "Josh Scott", "Brandon Aaron"]
  gem.email         = ["marlon@simpli.fi", "josh@simpli.fi"]
  gem.description   = %q{}
  gem.summary       = %q{Unofficial Ruby API Wrapper for Appnexus}
  gem.homepage      = "https://github.com/simplifi/appnexusapi"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "appnexusapi"
  gem.require_paths = ["lib"]
  gem.version       = AppnexusApi::VERSION

  gem.add_dependency 'faraday', '~> 0.9'
  gem.add_dependency 'faraday_middleware'
  gem.add_dependency 'multi_json'
  gem.add_dependency 'retriable', '>= 2.0'

  gem.add_development_dependency 'bundler', '>= 1.2.0'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'dotenv'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'webmock'
end
