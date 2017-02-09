require 'spec_helper'

describe AppnexusApi::AdvertiserService do
  let(:advertiser_service) { described_class.new(connection) }

  it 'supports a get operation' do
    VCR.use_cassette('advertiser_get') do
      expect { advertiser_service.get(num_elements: 1) }.to_not raise_error
    end
  end
end
