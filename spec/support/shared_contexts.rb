shared_context 'with an advertiser' do
  let(:advertiser_params) { { name: 'rspec advertiser' } }
  let(:advertiser) { AppnexusApi::AdvertiserService.new(connection).create({}, advertiser_params) }
  let(:advertiser_id) { advertiser.id }
  let(:advertiser_url_params) { { advertiser_id: advertiser_id } }
end

shared_context 'with a new line item' do
  include_context 'with an advertiser'

  let(:line_item_service) { AppnexusApi::LineItemService.new(connection) }
  let(:line_item_params) { { name: 'some line item', code: 'spec_line_code' } }
end

shared_context 'with a publisher' do
  let(:publisher_service) { AppnexusApi::PublisherService.new(connection) }
  let(:publisher) { publisher_service.create(publisher_url_params, publisher_params) }
  let(:publisher_url_params) { { create_default_placement: false } }
  let(:publisher_params) do
    {
      name: "spec publisher",
      code: 'spec_publisher_code',
      expose_domains: true,
      reselling_exposure: "public",
      ad_quality_advanced_mode_enabled: true
    }
  end
end
