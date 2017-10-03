class AppnexusApi::Service
  DEFAULT_NUMBER_OF_ELEMENTS = 100

  def initialize(connection)
    @connection = connection
  end

  def name
    @name ||= begin
      str = self.class.name.split('::').last.sub(/Service\z/, '')
      str.gsub(/(.)([A-Z])/, '\1_\2').downcase
    end
  end

  def plural_name
    name + 's'
  end

  def uri_name
    name.gsub('_', '-')
  end

  def plural_uri_name
    uri_name + 's'
  end

  def uri_suffix
    uri_name
  end

  def get(params = {})
    params = { 'num_elements' => DEFAULT_NUMBER_OF_ELEMENTS, 'start_element' => 0 }.merge(params)
    parse_response(@connection.get(uri_suffix, params).body['response'])
  end

  # Page through all available elements automatically
  def get_all(params = {})
    responses = []
    last_responses = get(params)

    while last_responses.size > 0
      responses += last_responses
      last_responses = get(params.merge('start_element' => responses.size))
    end

    responses
  end

  def create(route_params = {}, body = {})
    check_read_only!
    route = @connection.build_url(uri_suffix, route_params)
    response = @connection.post(route, { uri_name => body }).body['response']
    validate_response!(response)

    parse_response(response).first
  end

  def update(id, route_params = {}, body = {})
    check_read_only!
    route = @connection.build_url(uri_suffix, route_params.merge('id' => id))
    response = @connection.put(route, { uri_name => body }).body['response']
    validate_response!(response)

    parse_response(response).first
  end

  def delete(id, route_params)
    check_read_only!
    route = @connection.build_url(uri_suffix, route_params.merge('id' => id))
    response = @connection.delete(route).body['response']
    validate_response!(response)

    response
  end

  private

  def check_read_only!
    raise(AppnexusApi::NotImplemented, "Service is read-only.") if @read_only
  end

  def validate_response!(response)
    return unless response['error_id']

    response.delete('dbg')
    raise AppnexusApi::BadRequest.new(response.inspect)
  end

  def parse_response(response)
    case key = resource_name(response)
    when plural_name, plural_uri_name
      response[key].map { |json| AppnexusApi::Resource.new(json, self, response['dbg']) }
    when name, uri_name
      [AppnexusApi::Resource.new(response[key], self, response['dbg'])]
    end
  end

  def resource_name(response)
    [plural_name, plural_uri_name, name, uri_name].detect { |n| response.key?(n) }
  end
end
