class AppnexusApi::Service
  DEFAULT_NUMBER_OF_ELEMENTS = 100

  def initialize(connection)
    @connection = connection
  end

  def name
    @name ||= begin
      str = self.class.name.split("::").last.gsub("Service", "")
      str.gsub(/(.)([A-Z])/, '\1_\2').downcase
    end
  end

  def plural_name
    name + 's'
  end

  def resource_class
    @resource_class ||= begin
      resource_name = name.capitalize.gsub(/(_(.))/) { |c| $2.upcase }
      AppnexusApi.const_get(resource_name + "Resource")
    end
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

  def get(params={})
    return_response = params.delete(:return_response) || false
    params = {
      "num_elements" => DEFAULT_NUMBER_OF_ELEMENTS,
      "start_element" => 0
    }.merge(params)
    response = @connection.get(uri_suffix, params).body['response']
    if return_response
      response
    else
      parse_response(response)
    end
  end

  def get_all(params = {})
    responses = []
    last_responses = get(params)

    while last_responses.size > 0
      responses += last_responses
      last_responses = get(params.merge('start_element' => responses.size))
    end

    responses
  end

  def create(route_params={}, body={})
    raise(AppnexusApi::NotImplemented, "Service is read-only.") if @read_only
    body = { uri_name => body }
    route = @connection.build_url(uri_suffix, route_params)
    response = @connection.post(route, body).body['response']
    if response['error_id']
      response.delete('dbg')
      raise AppnexusApi::BadRequest.new(response.inspect)
    end
    parse_response(response).first
  end

  def update(id, route_params={}, body={})
    raise(AppnexusApi::NotImplemented, "Service is read-only.") if @read_only
    body = { uri_name => body }
    route = @connection.build_url(uri_suffix, route_params.merge("id" => id))
    response = @connection.put(route, body).body['response']
    if response['error_id']
      response.delete('dbg')
      raise AppnexusApi::BadRequest.new(response.inspect)
    end
    parse_response(response).first
  end

  def delete(id, route_params)
    raise(AppnexusApi::NotImplemented, "Service is read-only.") if @read_only
    route = @connection.build_url(uri_suffix, route_params.merge("id" => id))
    @connection.delete(route).body['response']
  end

  def parse_response(response)
    case key = resource_name(response)
    when plural_name, plural_uri_name
      response[key].map do |json|
        resource_class.new(json, self, response['dbg'])
      end
    when name, uri_name
      [resource_class.new(response[key], self, response['dbg'])]
    end
  end

  def resource_name(response)
    [plural_name, plural_uri_name, name, uri_name].detect { |n| response.key?(n) }
  end

end
