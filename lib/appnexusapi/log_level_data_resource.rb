class AppnexusApi::LogLevelDataResource < AppnexusApi::Resource
  # Extract an array of hashes of params to pass to the LogLevelDownloadService
  def download_params
    fail 'Missing necessaray information!' unless name && hour && timestamp && splits
    splits.map do |split_part|
      if split_part['checksum'].blank?
        # In the case of regenerated files, there can be no checksum.  These replaced hourly files should not be downloaded.
        nil
      else
        {
          split_part: split_part['part'],
          siphon_name: name,
          timestamp: timestamp,
          hour: hour,
          checksum: split_part['checksum']
        }
      end
    end.compact
  end
end
