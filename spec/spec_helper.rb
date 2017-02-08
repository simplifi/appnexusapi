require 'dotenv'
require 'pry'
require 'logger'
require 'vcr'
require 'webmock'
require_relative '../lib/appnexusapi'

DEFAULT_SPEC_USERNAME = 'user'
DEFAULT_SPEC_PASSWORD = 'pass'

Dotenv.load

module SpecWithConnection
  extend RSpec::SharedContext

  let(:test_logger) { Logger.new('./log/test.log') }

  let(:connection) do
    AppnexusApi::Connection.new(
      'username' => ENV['APPNEXUS_USERNAME'],
      'password' => ENV['APPNEXUS_PASSWORD'],
      'uri'      => ENV['APPNEXUS_URI'],
      'logger'   => test_logger
    )
  end

  let(:connection_with_null_logger) do
    AppnexusApi::Connection.new(
      'username' => ENV['APPNEXUS_USERNAME'],
      'password' => ENV['APPNEXUS_PASSWORD'],
      'uri'      => ENV['APPNEXUS_URI']
    )
  end
end

RSpec.configure do |config|
  config.before(:all) do
    FileUtils.mkdir_p('./log')
  end

  config.filter_run_excluding slow: true
  config.include SpecWithConnection
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr'
  c.hook_into :webmock

  c.allow_http_connections_when_no_cassette = true
  c.filter_sensitive_data('<APPNEXUS_USERNAME>')        { ENV['APPNEXUS_USERNAME'] || DEFAULT_SPEC_USERNAME }
  c.filter_sensitive_data('<APPNEXUS_PASSWORD>')        { ENV['APPNEXUS_PASSWORD'] || DEFAULT_SPEC_PASSWORD }

  c.default_cassette_options = {
    match_requests_on: [:method, :uri, :body]
  }
end
