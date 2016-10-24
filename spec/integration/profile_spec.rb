require 'spec_helper'

describe "profile service" do
  before(:all) do
    @connection = connection
    @advertiser_id = ENV['APPNEXUS_ADVERTISER_ID']
    if @advertiser_id.nil?
      advertiser_service = AppnexusApi::AdvertiserService.new(connection)
      advertiser_params = { name: "rspec test advertiser" }
      @advertiser = advertiser_service.create({}, advertiser_params)
      @advertiser_id = @advertiser.id
    end
    @line_item_service = AppnexusApi::LineItemService.new(@connection)
    @profile_service   = AppnexusApi::ProfileService.new(@connection)
  end

  after(:all) do
    @advertiser.delete if @advertiser
  end

  it "profile life cycle" do
    # create a profile
    profile_url_params = { :advertiser_id => @advertiser_id }
    profile_params = {
      :code => "spec_profile_code_#{Time.now.to_i}_#{rand(9_000_000)}",
      :description => "Targeting only the US",
      :country_targets => [ { :id => 233 } ],
      :country_action  => "include"
    }

    profile = @profile_service.create(profile_url_params, profile_params)
    profile.description.should == "Targeting only the US"
    profile.country_targets.should == [{"id"=>233,"code"=>"US", "name"=>"United States"}]

    # create a line item
    new_line_item_url_params = {
      :advertiser_id => @advertiser_id
    }

    new_line_item_params = {
      name: "some line item #{rand(100_000)}",
      code: "spec_line_code_#{rand(100_000)}",
      profile_id: profile.id
    }

    new_line_item = @line_item_service.create new_line_item_url_params, new_line_item_params

    new_line_item.profile_id.should == profile.id

    # delete the line item
    new_line_item.delete({"advertiser_id" => @advertiser_id})
  end
end
