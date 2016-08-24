require 'spec_helper'

describe AppnexusApi::Connection do

  it 'allows no logger to be specified' do
    expect do
      AppnexusApi::CreativeService.new(connection_with_null_logger, ENV['APPNEXUS_MEMBER_ID'])
    end.to_not raise_error
  end

end
