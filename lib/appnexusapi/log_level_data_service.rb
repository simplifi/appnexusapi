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

    get(params)
  end

  def uri_name
    'siphon'
  end
end
