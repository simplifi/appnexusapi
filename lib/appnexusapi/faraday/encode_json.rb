module AppnexusApi
  module Faraday
    module Request
      class JsonEncode < ::Faraday::Middleware
        def call(env)
          if env[:request_headers]["Content-Type"] == nil
            env[:body] = MultiJson.encode(env[:body]) if env[:body] != nil
            env[:request_headers]["Content-Type"] = "application/json"
          end
          @app.call(env)
        end
      end
    end
  end
end
