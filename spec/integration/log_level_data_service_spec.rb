require 'spec_helper'

describe AppnexusApi::LogLevelDataService do
  after(:each) do
    system('rm standard_feed_2017_02_13_00_0.gz')
  end

  it 'downloads new files' do
    VCR.use_cassette('log_level_data_service_download') do
      described_class.new(connection).download_new_files_since(Time.new(2017, 2, 13, 2, 2, 2))
    end
  end
end
