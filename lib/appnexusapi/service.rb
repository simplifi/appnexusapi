class AppnexusApi::Service

  def initialize(connection)
    @connection = connection
  end

  def name
    str = self.class.name.split("::").last.gsub("Service", "")
    str.gsub(/(.)([A-Z])/, '\1_\2').downcase
  end

  def plural_name
    name + 's'
  end

  def resource_class
    resource_name = name.capitalize.gsub(/(_(.))/) { |c| $2.upcase }
    AppnexusApi.const_get(resource_name + "Resource")
  end

  def uri_suffix
    name.gsub('_', '-')
  end

  def get(params={})
    params = {
      "num_elements" => 100,
      "start_element" => 0
    }.merge(params)
    response = @connection.get(uri_suffix, params)
    if response.has_key?(plural_name)
      response[plural_name].map do |json|
        resource_class.new(json, self)
      end
    elsif response.has_key?(name)
      [resource_class.new(response[name], self)]
    end
  end

  def create(attributes={})
    raise(AppnexusApi::NotImplemented, "Service is read-only.") if @read_only
    attributes = { name => attributes }
    response = @connection.post(uri_suffix, attributes)
    get("id" => response["id"]).first
  end

  def update(id, attributes={})
    raise(AppnexusApi::NotImplemented, "Service is read-only.") if @read_only
    attributes = { name => attributes }
    response = @connection.put([uri_suffix, id].join('/'), attributes)
    get("id" => response["id"]).first
  end

  def delete(id)
    raise(AppnexusApi::NotImplemented, "Service is read-only.") if @read_only
    @connection.delete([uri_suffix, id].join('/'))
  end

end
