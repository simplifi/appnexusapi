class AppnexusApi::SegmentService < AppnexusApi::Service
  def initialize(connection, member_id)
    @member_id = member_id
    super(connection)
  end

  def uri_suffix
    "#{super}/#{@member_id}"
  end
end
