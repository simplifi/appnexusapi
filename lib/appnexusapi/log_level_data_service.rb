class AppnexusApi::LogLevelDataService < AppnexusApi::Service
  def initialize(connection)
    @read_only = true
    super
  end

  def since(time = nil)
    if time
      get(updated_since: time.strftime('%Y_%m_%d_%H'))
    else
      get
    end
  end

  def uri_name
    'siphon'
  end
end
