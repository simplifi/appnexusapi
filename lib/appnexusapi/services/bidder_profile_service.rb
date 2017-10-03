class AppnexusApi::BidderProfileService < AppnexusApi::Service
  def initialize(connection, bidder_id)
    @bidder_id = bidder_id
    super(connection)
  end

  def name
    "profile"
  end

  def uri_suffix
    "profile/#{@bidder_id}"
  end

  def delete(id)
    raise AppnexusApi::NotImplemented
  end
end
