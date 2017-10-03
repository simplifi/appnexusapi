class AppnexusApi::AdServerService < AppnexusApi::ReadOnlyService
  def name
    "adserver"
  end

  def uri_suffix
    "ad-server"
  end
end
