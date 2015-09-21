class AppnexusApi::LogLevelDataDownloadService < AppnexusApi::Service
  def initialize(connection)
    @read_only = true
    super
  end

  def download_location(params={})
    @connection.get(uri_suffix, params).headers['location']
  end

  def get
    raise(AppnexusApi::NotImplemented, "This service is designed to work through download_location method")
  end

  def uri_name
    'siphon-download'
  end
end
