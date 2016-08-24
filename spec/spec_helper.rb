require 'dotenv'
Dotenv.load

require 'pry'
require 'logger'
require_relative '../lib/appnexusapi'

RSpec.configure do |c|
  c.filter_run_excluding :slow => true
end

def test_logger
  return @logger unless @logger.nil?
  FileUtils.mkdir_p('./log')
  @logger = Logger.new('./log/test.log')
  @logger.level = Logger::INFO
  @logger
end

def connection
  AppnexusApi::Connection.new(
    'username' => ENV['APPNEXUS_USERNAME'],
    'password' => ENV['APPNEXUS_PASSWORD'],
    'uri'      => ENV['APPNEXUS_URI'],
    'logger'   => test_logger
  )
end

def connection_with_null_logger
  AppnexusApi::Connection.new(
    'username' => ENV['APPNEXUS_USERNAME'],
    'password' => ENV['APPNEXUS_PASSWORD'],
    'uri'      => ENV['APPNEXUS_URI']
  )
end

