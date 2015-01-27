require 'spec_helper'

describe "AppNexus Site" do
  before(:all) do
    @connection = connection
    @publisher_service = AppnexusApi::PublisherService.new(@connection)
    @site_service      = AppnexusApi::SiteService.new(@connection)
    @placement_service = AppnexusApi::PlacementService.new(@connection)
  end

  it "default placement" do

    # have to create a publisher first
    code = "spec_pub_code_#{Time.now.to_i}_#{rand(9_000_000)}"
    # new_publisher_url_params = { create_default_placement: true }
    new_publisher_url_params = { }
    new_publisher_params = {
      name: "Publisher Foo Name",
      code: code,
      expose_domains: true,
      reselling_exposure: "public",
      ad_quality_advanced_mode_enabled: true
    }

    publisher = @publisher_service.create(new_publisher_url_params,
                                          new_publisher_params)

    # now grab the default site
    default_site = @site_service.get(id: publisher.default_site_id, publisher_id: publisher.id).first


    # grab the default placement
    default_placement = @placement_service.get(id: default_site.placements.first["id"]).first
    default_placement.name.should  == "[Publisher Foo Name] - Default"
    default_placement.state.should == "active"

    default_site.delete
    publisher.delete
  end
end
