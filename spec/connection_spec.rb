require 'spec_helper'

describe AppnexusApi::Connection do
  subject { AppnexusApi::Connection.new({}) }

  it 'allows no logger to be specified' do
    expect do
      AppnexusApi::CreativeService.new(connection_with_null_logger)
    end.to_not raise_error
  end

  it 'returns data from expiration' do
    #stub to raise error the first time and then return []
    @counter = 0
    allow(subject).to receive(:run_request_only) do |arg|
      @counter += 1
      raise AppnexusApi::Unauthorized.new if @counter == 1
      Faraday::Response.new(body: {not_an_error: 1})
    end
    expect(subject.run_request(:get, "http://localhost", nil, {})).not_to eq({})
  end

end
