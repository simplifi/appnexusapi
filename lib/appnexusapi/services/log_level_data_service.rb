module AppnexusApi
  class LogLevelDataService < AppnexusApi::ReadOnlyService
    DEFAULT_FEED = 'standard_feed'.freeze
    DOWNLOAD_URI = 'siphon-download'.freeze
    RETRY_DOWNLOAD_PARAMS = {
      base_interval: 30,
      tries: 20,
      max_elapsed_time: 3600,
      on: [AppnexusApi::Error, ::Faraday::Error::ClientError],
      on_retry: Proc.new do |exception, tries|
        AppnexusApi.config.logger.warn("Retrying after #{exception.class}: #{tries} attempts.")
      end
    }.freeze

    def initialize(connection, options = {})
      @downloaded_files_path = options[:downloaded_files_path] || '.'
      @siphon_name = options[:siphon_name] || DEFAULT_FEED
      super(connection)
    end

    def download_new_files_since(time = nil)
      since(time).map { |siphon| download_resource(siphon) }
    end

    def uri_name
      'siphon'
    end

    def since(time = nil)
      params = {}
      params[:siphon_name] = @siphon_name if @siphon_name
      params[:updated_since] = time.strftime('%Y_%m_%d_%H') if time
      siphons = get(params) || {}

      # Anything with the same name and hour but with a newer timestamp is a republished replacement for an older file.
      # When this happens appnexus is supposed to set the checksum for the old file to NULL but they do not always
      # actually do this, so we have to manually reject invalid entries.
      siphons.reject do |siphon|
        (siphons - [siphon]).any? { |s| s.name == siphon.name && s.hour == siphon.hour && s.timestamp > siphon.timestamp }
      end
    end

    private

    # Parameter is a LogLevelDataResource FKA a "Siphon"
    # Downloads a gzipped file
    # Returns an array of paths to downloaded files
    def download_resource(siphon)
      fail 'Missing necessary information!' unless siphon.name && siphon.hour && siphon.timestamp && siphon.splits

      download_params = siphon.splits.map do |split_part|
        # In the case of files that were later replaced, there should be no checksum and they shouldn't be downloaded
        next nil if split_part['checksum'].nil? || split_part['checksum'].empty?

        {
          split_part: split_part['part'],
          siphon_name: siphon.name,
          timestamp: siphon.timestamp,
          hour: siphon.hour,
          checksum: split_part['checksum']
        }
      end.compact

      download_params.map do |params|
        uri = URI.parse(@connection.get(DOWNLOAD_URI, params.reject { |k, v| k == :checksum }).headers['location'])
        filename = File.join(@downloaded_files_path, "#{params[:siphon_name]}_#{params[:hour]}_#{params[:split_part]}.gz")

        Retriable.retriable(RETRY_DOWNLOAD_PARAMS) do
          download_file(uri, filename)
          calculated_checksum = Digest::MD5.hexdigest(File.read(filename))
          if calculated_checksum != params[:checksum]
            error_message = "Calculated checksum of #{calculated_checksum} doesn't match API provided checksum #{params[:checksum]}"
            AppnexusApi.config.logger.fatal(error_message)
            raise BadChecksumException, error_message
          end
        end

        filename
      end
    end

    def download_file(uri, filename)
      AppnexusApi.config.logger.debug("Starting HTTP download for: #{uri.to_s}...")
      http_object = Net::HTTP.new(uri.host, uri.port)
      http_object.use_ssl = true if uri.scheme == 'https'

      begin
        http_object.start do |http|
          request = Net::HTTP::Get.new(uri.request_uri)
          http.read_timeout = 500

          http.request(request) do |response|
            open(filename, 'wb') do |io|
              response.read_body do |chunk|
                io.write(chunk)
              end
            end
          end
        end
      end

      AppnexusApi.config.logger.info("Stored download of #{uri.to_s} as #{filename}")
    end
  end
end
