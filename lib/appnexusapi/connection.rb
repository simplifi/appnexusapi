require 'faraday_middleware'

class AppnexusApi::Connection
  def initialize(config)
    @config = config
    @config["uri"] ||= "http://api.adnxs.com/"
    @connection = Faraday::Connection.new(:url => @config["uri"]) do |builder|
      builder.use FaradayMiddleware::EncodeJson
      builder.use FaradayMiddleware::ParseJson
      builder.adapter Faraday.default_adapter
    end
  end

  def is_authorized?
    !@token.nil?
  end

  def login
    response = @connection.run_request(:post, 'auth', { "auth" => { "username" => @config["username"], "password" => @config["password"] } }, {})
    @token = response.body["response"]["token"]
  end

  def logout
    @token = nil
  end

  def get(route, params={}, headers={})
    params = params.delete_if {|key, value| value.nil? }
    run_request(:get, @connection.build_url(route, params), nil, headers).body['response']
  end

  def post(route, body=nil, headers={})
    run_request(:post, route, body, headers).body['response']
  end

  def put(route, body=nil, headers={})
    run_request(:put, route, body, headers).body['response']
  end

  def delete(route, body=nil, headers={})
    run_request(:delete, route, body, headers).body['response']
  end

  def run_request(method, route, body, headers)
    login if !is_authorized?
    begin
      @connection.run_request(method, route, body, { "Authorization" => @token }.merge(headers))
    rescue AppnexusApi::Unauthorized => e
      if @retry == true
        raise AppnexusApi::Unauthorized, e
      else
        @retry = true
        logout
        run_request(method, route, body, headers)
      end
    rescue Faraday::Error::TimeoutError => e
      raise AppnexusApi::Timeout, "Timeout"
    ensure
      @retry = false
    end
  end
end
