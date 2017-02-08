require 'spec_helper'

describe AppnexusApi::MemberService do
  it 'returns the current member' do
    VCR.use_cassette('member_get') do
      described_class.new(connection).get
    end
  end
end
