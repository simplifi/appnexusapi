class AppnexusApi::TinyTagService < AppnexusApi::Service

  def initialize(connection, member_id)
    @member_id = member_id
    super(connection)
  end

  def name
    "tinytag"
  end

  def resource_class
    AppnexusApi::TinyTagResource
  end

  def uri_suffix
    "tt/#{@member_id}"
  end

end
