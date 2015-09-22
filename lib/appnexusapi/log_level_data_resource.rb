class AppnexusApi::LogLevelDataResource < AppnexusApi::Resource
  # Extract an array of hashes of params to pass to the LogLevelDownloadService
  def download_params
    fail 'Missing necessaray information!' unless name && hour && timestamp && splits
    splits.map do |split_part|
      {
        split_part: split_part['part'],
        siphon_name: name,
        timestamp: timestamp,
        hour: hour
      }
    end
  end
end
