require 'spec_helper'

describe AppnexusApi::ObjectLimitService do
  let(:object_limit_service) do
    AppnexusApi::ObjectLimitService.new(connection)
  end

  it "returns info about your current creative limits" do
    creative_limits = object_limit_service.creative_limits.raw_json
    expect(creative_limits["object_type"]).to eq "creative"
    expect(creative_limits["limit"].to_i).to be > 0
  end

  it "returns info about your current profile limits" do
    profile_limits = object_limit_service.profile_limits.raw_json
    expect(profile_limits["object_type"]).to eq "profile"
  end

  it "returns info about your current domain list limits" do
    domain_list_limits = object_limit_service.domain_list_limits.raw_json
    expect(domain_list_limits["object_type"]).to eq "domain_list"
  end
end

