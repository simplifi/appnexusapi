require 'spec_helper'

describe AppnexusApi::CampaignService do
  let(:advertiser_service) { AppnexusApi::AdvertiserService.new(connection) }
  let(:line_item_service) { AppnexusApi::LineItemService.new(connection) }
  let(:campaign_service) { AppnexusApi::CampaignService.new(connection) }
  let(:advertiser_params) { { name: 'rspec advertiser' } }
  let(:advertiser) { advertiser_service.create({}, advertiser_params) }
  let(:advertiser_id) { advertiser.id }
  let(:url_params) { { advertiser_id: advertiser_id } }

  it 'executes a campaigns life cycle' do
    VCR.use_cassette('campaign_life_cycle') do
      # create a profile

      profile_params = {
        code: 'spec_profile_code',
        description: 'Targeting only the US',
        country_targets: [ { id: 233 } ],
        country_action: 'include'
      }

      profile = AppnexusApi::ProfileService.new(connection).create(url_params, profile_params)

      # create a new line item
      new_line_item_params = {
        name: "some line item",
        code: "spec_line_code"
      }

      new_line_item = line_item_service.create(url_params, new_line_item_params)

      campaign_params = {
        :name => "campaign name",
        :code => "codecode",
        :line_item_id => new_line_item.id,
        :inventory_type => "direct",
        # profile is what targets Geo
        :profile_id => profile.id
      }
      campaign = described_class.new(connection).create(url_params, campaign_params)
      expect(campaign.name).to eq('campaign name')
      expect(campaign.profile_id).to eq(profile.id)

      # delete the campaign
      campaign.delete(url_params)
      # delete the line item
      new_line_item.delete({ 'advertiser_id' => advertiser_id })
      # delete the profile
      profile.delete(url_params)
      advertiser.delete
    end
  end
end
