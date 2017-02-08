shared_context 'with an advertiser' do
  let(:advertiser_params) { { name: 'rspec advertiser' } }
  let(:advertiser) { AppnexusApi::AdvertiserService.new(connection).create({}, advertiser_params) }
  let(:advertiser_id) { advertiser.id }
end
