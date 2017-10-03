require 'spec_helper'

describe AppnexusApi::ObjectLimitService do
  let(:object_limit_service) { described_class.new(connection) }

  it "returns info about your current creative limits" do
    VCR.use_cassette('object_limit_info') do
      creative_limits = object_limit_service.creative_limits.raw_json
      expect(creative_limits["object_type"]).to eq "creative"
      expect(creative_limits["limit"].to_i).to be > 0
    end
  end

  it "returns info about your current profile limits" do
    VCR.use_cassette('profile_limits') do
      profile_limits = object_limit_service.profile_limits.raw_json
      expect(profile_limits["object_type"]).to eq "profile"
    end
  end

  it "returns info about your current domain list limits" do
    VCR.use_cassette('domain_list_limits') do
      domain_list_limits = object_limit_service.domain_list_limits.raw_json
      expect(domain_list_limits["object_type"]).to eq "domain_list"
    end
  end
end
