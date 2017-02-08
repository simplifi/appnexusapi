require 'spec_helper'

describe AppnexusApi::ProfileService do
  include_context 'with a new line item'

  let(:profile_service) { described_class.new(connection) }
  let(:profile_descript) { 'Targeting only the US' }

  it "profile life cycle" do
    VCR.use_cassette('profile_life_cycle') do
      profile_params = {
        :code => "spec_profile_code",
        :description => profile_descript,
        :country_targets => [ { :id => 233 } ],
        :country_action  => "include"
      }

      profile = profile_service.create(advertiser_url_params, profile_params)
      expect(profile.description).to eq(profile_descript)
      expect(profile.country_targets).to eq([{ "id"=>233,"code"=>"US", "name"=>"United States", "active"=>true }])

      new_line_item = line_item_service.create(advertiser_url_params, line_item_params.merge(profile_id: profile.id))
      new_line_item.profile_id.should == profile.id

      new_line_item.delete({ "advertiser_id" => advertiser_id })
      advertiser.delete
    end
  end
end
