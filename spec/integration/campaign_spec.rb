require 'spec_helper'

describe "campaign service" do
  before(:all) do
    @connection = connection
    @advertiser_id = 20393
    @line_item_service = AppnexusApi::LineItemService.new(@connection)
    @campaign_service  = AppnexusApi::CampaignService.new(@connection)
    @profile_service   = AppnexusApi::ProfileService.new(@connection)
  end

  it "campaign life cycle" do
    # create a profile
    profile_url_params = { :advertiser_id => @advertiser_id }
    profile_params = {
      :code => "profile_code_#{Time.now.to_i}_#{rand(9_000_000)}",
      :description => "Targeting only the US",
      :country_targets => [ { :country => "US" } ],
      :country_action  => "include"
    }

    profile = @profile_service.create(profile_url_params, profile_params)


    # create a new line item
    new_line_item_url_params = {
      :advertiser_id => @advertiser_id
    }

    new_line_item_params = {
      name: "some line item #{rand(100_000)}",
      code: "somecode_#{Time.now.to_i}_#{rand(100_000)}"
    }

    new_line_item = @line_item_service.create( new_line_item_url_params,
                                               new_line_item_params )

    campaign_url_params = {advertiser_id: @advertiser_id}
    campaign_params = {
      :name => "campaign name",
      :code => "codecode_#{Time.now.to_i}_#{rand(9_000_000)}",
      :line_item_id => new_line_item.id,
      :inventory_type => "direct",
      # profile is what targets Geo
      :profile_id => profile.id
    }
    campaign = @campaign_service.create(campaign_url_params, campaign_params)
    campaign.name.should == "campaign name"
    campaign.profile_id.should == profile.id

    # delete the campaign
    campaign.delete campaign_url_params
    # delete the line item
    new_line_item.delete({"advertiser_id" => @advertiser_id})
    # delete the profile
    profile.delete profile_url_params
  end
end
