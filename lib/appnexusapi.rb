require 'faraday'
require 'faraday_middleware'
require 'logger'
require 'retriable'

require 'appnexusapi/configuration'
require 'appnexusapi/version'
require 'appnexusapi/error'
require 'appnexusapi/resource'
require 'appnexusapi/service'
require 'appnexusapi/read_only_service'
require 'appnexusapi/connection'

Dir.glob("#{File.join(File.dirname(__FILE__), 'appnexusapi', 'services')}/*.rb").each do |service_file|
  require service_file
end

module AppnexusApi
  def self.config
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(config)
  end
end
