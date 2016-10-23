require 'spec_helper'

describe "AppNexus Advertiser" do
  pending 'writeme, testme, useme'

  let(:advertiser_service) do
    AppnexusApi::AdvertiserService.new(connection)
  end

  it 'supports a get operation' do
    expect do
      advertiser_service.get(num_elements: 1)
    end.to_not raise_error
  end

end
