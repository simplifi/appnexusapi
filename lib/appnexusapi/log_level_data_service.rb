class AppnexusApi::LogLevelDataService < AppnexusApi::Service
  def initialize(connection)
    @read_only = true
    super
  end

  def uri_name
    'siphon'
  end
end
