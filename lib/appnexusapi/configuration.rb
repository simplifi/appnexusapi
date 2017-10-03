module AppnexusApi
  class Configuration
    attr_accessor :api_debug, :logger

    def initialize
      @api_debug = ENV['APPNEXUS_API_DEBUG'].to_s =~ /^(true|t|yes|y|1)$/i
      @logger = Logger.new(STDOUT).tap do |logger|
        @api_debug ? logger.level = Logger::DEBUG : logger.level = Logger::INFO
      end
    end
  end
end
