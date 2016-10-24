require 'spec_helper'

describe 'Appnexus Member' do
  before(:all) do
    @connection = connection
    @member_service = AppnexusApi::MemberService.new(@connection)
  end


  it 'returns the current member' do
    @member_service.get
  end
end
