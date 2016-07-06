class AppnexusApi::LogLevelDataService < AppnexusApi::Service
  def initialize(connection, options = {})
    @read_only = true
    @siphon_name = options[:siphon_name]

    super(connection)
  end

  def since(time = nil)
    params = {}
    params[:siphon_name] = @siphon_name if @siphon_name
    params[:updated_since] = time.strftime('%Y_%m_%d_%H') if time

    # Anything with the same name and hour but with a newer timestamp is a republished replacement for an older file
    # When this happens appnexus is supposed to set the checksum for the old file to null but they do not always
    # actually do this.
    siphons = get(params)
    siphons.reject do |siphon|
      (siphons - [siphon]).any? { |s| s.name == siphon.name && s.hour == siphon.hour && s.timestamp > siphon.timestamp }
    end
  end

  def uri_name
    'siphon'
  end
end
