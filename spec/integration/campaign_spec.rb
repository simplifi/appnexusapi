require 'spec_helper'

describe AppnexusApi::CampaignService do
  include_context 'with a new line item'

  let(:campaign_name) { 'campaign name' }
  let(:profile_params) do
    {
      code: 'spec_profile_code',
      description: 'Targeting only the US',
      country_targets: [ { id: 233 } ],
      country_action: 'include'
    }
  end

  it 'executes a campaigns life cycle' do
    VCR.use_cassette('campaign_life_cycle') do
      profile = AppnexusApi::ProfileService.new(connection).create(advertiser_url_params, profile_params)
      new_line_item = AppnexusApi::LineItemService.new(connection).create(advertiser_url_params, line_item_params)
      campaign_params = {
        name: campaign_name,
        code: 'codecode',
        line_item_id: new_line_item.id,
        inventory_type: 'direct',
        profile_id: profile.id # profile is what targets Geo
      }
      campaign = described_class.new(connection).create(advertiser_url_params, campaign_params)

      expect(campaign.name).to eq('campaign name')
      expect(campaign.profile_id).to eq(profile.id)

      campaign.delete(advertiser_url_params)
      new_line_item.delete('advertiser_id' => advertiser_id)
      profile.delete(advertiser_url_params)
      advertiser.delete
    end
  end
end
