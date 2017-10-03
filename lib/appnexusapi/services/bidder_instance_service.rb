class AppnexusApi::BidderInstanceService < AppnexusApi::Service
  def initialize(connection, bidder_id)
    @bidder_id = bidder_id
    super(connection)
  end

  def name
    "instance"
  end

  def uri_suffix
    "bidder-instance/#{@bidder_id}"
  end

  def delete(id)
    raise AppnexusApi::NotImplemented, "To remove an instance, please set it to inactive."
  end
end
