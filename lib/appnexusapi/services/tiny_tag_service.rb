class AppnexusApi::TinyTagService < AppnexusApi::Service
  def initialize(connection, member_id)
    @member_id = member_id
    super(connection)
  end

  def name
    "tinytag"
  end

  def uri_suffix
    "tt/#{@member_id}"
  end
end
