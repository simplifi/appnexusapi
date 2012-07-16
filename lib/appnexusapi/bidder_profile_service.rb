class AppnexusApi::BidderProfileResource < AppnexusApi::Service

  def initialize(connection, bidder_id)
    @bidder_id = bidder_id
    super(connection)
  end

  def name
    "profile"
  end

  def resource_class
    AppnexusApi::BidderProfileResource
  end

  def uri_suffix
    "bidder-profile/#{@bidder_id}"
  end

  def delete(id)
    raise AppnexusApi::NotImplemented
  end

end
