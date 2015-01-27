require 'spec_helper'

describe "AppNexus Site" do
  before(:all) do
    @connection = connection
    @publisher_service = AppnexusApi::PublisherService.new(@connection)
    @site_service = AppnexusApi::SiteService.new(@connection)
  end

  it "site life cycle" do

    # have to create a publisher first
    code = "spec_pub_code_#{Time.now.to_i}_#{rand(9_000_000)}"
    new_publisher_url_params = { create_default_placement: false }
    new_publisher_params = {
      name: "Publisher Name",
      code: code,
      expose_domains: true,
      reselling_exposure: "public",
      ad_quality_advanced_mode_enabled: true
    }

    publisher = @publisher_service.create(new_publisher_url_params,
                                          new_publisher_params)


    # now create the site
    code = "spec_site_code_#{Time.now.to_i}_#{rand(9_000_000)}"
    new_site_url_params = { publisher_id: publisher.id }
    new_site_params = {
      name: "Site Name",
      code: code,
      url: "http://www.example.com",
      intended_audience: "general",
      audited: true
    }

    new_site = @site_service.create(new_site_url_params, new_site_params)
    new_site.name.should == "Site Name"
    new_site.code.should == code
    new_site.url.should  == "http://www.example.com"
    new_site.intended_audience.should == "general"
    new_site.audited.should == true

    new_site.delete
  end
end
