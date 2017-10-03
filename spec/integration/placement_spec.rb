require 'spec_helper'

describe AppnexusApi::PlacementService do
  include_context 'with a publisher'

  let(:placement_service) { described_class.new(connection) }

  it "default placement" do
    pending 'seems to rely on a configured default_site_id'
    raise 'seems to rely on a configured default_site_id'

    VCR.use_cassette('placement_service_default_placement') do
      # now grab the default site
      default_site = AppnexusApi::SiteService.new(connection).get(
        id: publisher.default_site_id,
        publisher_id: publisher.id
      ).first

      # grab the default placement
      default_placement = placement_service.get(id: default_site.placements.first["id"]).first
      default_placement.name.should  == "[Publisher Name] - Default"
      default_placement.state.should == "active"

      default_site.delete
      publisher.delete
    end
  end
end
