require 'faraday_middleware'
require 'appnexusapi/faraday/raise_http_error'

class AppnexusApi::Connection
  RATE_EXCEEDED_TIMEOUT = 5
  RATE_EXCEEDED_CODE = "RATE_EXCEEDED"

  def initialize(config)
    @config = config
    @config['uri'] ||= 'https://api.appnexus.com/'
    @connection = Faraday.new(@config['uri']) do |conn|
      if ENV['APPNEXUS_API_DEBUG'].to_s =~ /^(true|1)$/i
        conn.response :logger, Logger.new(STDERR), bodies: true
      end

      conn.request :json
      conn.response :json, :content_type => /\bjson$/
      conn.use AppnexusApi::Faraday::Response::RaiseHttpError
      conn.adapter Faraday.default_adapter
    end
  end

  def is_authorized?
    !@token.nil?
  end

  def login
    response = @connection.run_request(:post, 'auth', { 'auth' => { 'username' => @config['username'], 'password' => @config['password'] } }, {})
    if response.body['response']['error_code']
      fail "#{response.body['response']['error_code']}/#{response.body['response']['error_description']}"
    end
    @token = response.body['response']['token']
  end

  def logout
    @token = nil
  end

  def get(route, params={}, headers={})
    params = params.delete_if {|key, value| value.nil? }
    run_request(:get, @connection.build_url(route, params), nil, headers)
  end

  def post(route, body=nil, headers={})
    run_request(:post, route, body, headers)
  end

  def put(route, body=nil, headers={})
    run_request(:put, route, body, headers)
  end

  def delete(route, body=nil, headers={})
    run_request(:delete, route, body, headers)
  end

  def run_request(method, route, body, headers)
    login if !is_authorized?
    response = {}
    begin
      while true
        response = @connection.run_request(method, route, body, { 'Authorization' => @token }.merge(headers))
        break unless response.body["response"]["error_code"] == RATE_EXCEEDED_CODE
        sleep RATE_EXCEEDED_TIMEOUT
      end
    rescue AppnexusApi::Unauthorized => e
      if @retry == true
        raise AppnexusApi::Unauthorized, e
      else
        @retry = true
        logout
        run_request(method, route, body, headers)
      end
    rescue Faraday::Error::TimeoutError => e
      raise AppnexusApi::Timeout, 'Timeout'
    ensure
      @retry = false
    end
    response
  end
end
