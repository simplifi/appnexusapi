class AppnexusApi::AdServerService < AppnexusApi::Service

  def initialize(connection)
    @read_only = true
    super(connection)
  end

  def name
    "adserver"
  end

  def resource_class
    ApnexusApi::AdServerResource
  end

  def uri_suffix
    "ad-server"
  end

end
