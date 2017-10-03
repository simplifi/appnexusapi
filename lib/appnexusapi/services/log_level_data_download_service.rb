require 'appnexusapi/services/log_level_data_service'

# TODO: Remove this class in v2.0
module AppnexusApi
  class LogLevelDataDownloadService < LogLevelDataService
    extend Gem::Deprecate

    def initialize(connection, options = {})
      super
    end
    deprecate :initialize, 'LogLevelDataService#initialize', 2017, 6
  end
end
