require 'dotenv'
require 'pry'
require 'logger'
require 'vcr'
require 'webmock'
require_relative '../lib/appnexusapi'
Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

DEFAULT_SPEC_USERNAME = 'user'
DEFAULT_SPEC_PASSWORD = 'pass'

Dotenv.load

module SpecWithConnection
  extend RSpec::SharedContext

  let(:test_logger) { Logger.new('./log/test.log') }
  let(:connection) { AppnexusApi::Connection.new(connection_params.merge('logger' => test_logger)) }
  let(:connection_params) do
    {
      'username' => ENV['APPNEXUS_USERNAME'] || 'user',
      'password' => ENV['APPNEXUS_PASSWORD'] || 'pass',
      'uri'      => ENV['APPNEXUS_URI'] || 'https://api-test.appnexus.com'
    }
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    FileUtils.mkdir_p('./log')

    if ENV['APPNEXUS_USERNAME'] && ENV['APPNEXUS_PASSWORD']
      puts 'Attempting to destroy rspec created records on the Appnexus test server...'
      connection_params = {
        'username' => ENV['APPNEXUS_USERNAME'],
        'password' => ENV['APPNEXUS_PASSWORD'],
        'uri'      => ENV['APPNEXUS_URI'] || 'https://api-test.appnexus.com'
      }

      connection = AppnexusApi::Connection.new(connection_params.merge('logger' => Logger.new('./log/test.log')))

      AppnexusApi::PublisherService.new(connection).get.each { |p| p.delete if p.name =~ /spec/ || p.code =~ /spec/ }
      AppnexusApi::AdvertiserService.new(connection).get.each { |a| a.delete if a.name =~ /spec/ }
    end
  end

  config.filter_run_excluding slow: true
  config.include SpecWithConnection
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr'
  c.hook_into :webmock

  c.allow_http_connections_when_no_cassette = true
  c.filter_sensitive_data('<APPNEXUS_USERNAME>') { ENV['APPNEXUS_USERNAME'] || DEFAULT_SPEC_USERNAME }
  c.filter_sensitive_data('<APPNEXUS_PASSWORD>') { ENV['APPNEXUS_PASSWORD'] || DEFAULT_SPEC_PASSWORD }

  c.default_cassette_options = {
    match_requests_on: [:method, :uri, :body]
  }
end
