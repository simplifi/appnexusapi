require 'spec_helper'

describe AppnexusApi::CampaignService do
  let(:advertiser_service) { AppnexusApi::AdvertiserService.new(connection) }
  let(:line_item_service) { AppnexusApi::LineItemService.new(connection) }
  let(:campaign_service) { AppnexusApi::CampaignService.new(connection) }
  let(:profile_service) { AppnexusApi::ProfileService.new(connection) }
#  let(:advertiser_id { ENV['APPNEXUS_ADVERTISER_ID'] }
  let(:advertiser_params) { { name: 'rspec advertiser' } }
  let(:advertiser) { advertiser_service.create({}, advertiser_params) }
  let(:advertiser_id) { advertiser.id }

  it "campaign life cycle" do
    VCR.use_cassette('campaign_life_cycle') do
      # create a profile
      profile_url_params = { advertiser_id: advertiser_id }
      profile_params = {
        code: 'spec_profile_code',
        description: 'Targeting only the US',
        country_targets: [ { id: 233 } ],
        country_action: 'include'
      }

      profile = profile_service.create(profile_url_params, profile_params)

      # create a new line item
      new_line_item_url_params = { advertiser_id: advertiser_id }

      new_line_item_params = {
        name: "some line item",
        code: "spec_line_code"
      }

      new_line_item = line_item_service.create(new_line_item_url_params, new_line_item_params)

      campaign_url_params = { advertiser_id: advertiser_id }
      campaign_params = {
        :name => "campaign name",
        :code => "codecode",
        :line_item_id => new_line_item.id,
        :inventory_type => "direct",
        # profile is what targets Geo
        :profile_id => profile.id
      }
      campaign = campaign_service.create(campaign_url_params, campaign_params)
      campaign.name.should == "campaign name"
      campaign.profile_id.should == profile.id

      # delete the campaign
      campaign.delete campaign_url_params
      # delete the line item
      new_line_item.delete({"advertiser_id" => advertiser_id})
      # delete the profile
      profile.delete(profile_url_params)
      advertiser.delete if advertiser
    end
  end
end
