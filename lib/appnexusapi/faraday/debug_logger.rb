require 'forwardable'

module AppnexusApi
  module Faraday
    module Response
      class DebugLogger < ::Faraday::Middleware
        extend Forwardable

        def initialize(app, logger = nil)
          @logger = logger || begin
            require 'logger'
            ::Logger.new(STDOUT)
          end
          @app = app
        end

        def_delegators :@logger, :debug, :info, :warn, :error, :fatal

        def call(env)
          info "#{env[:method]} #{env[:url].to_s}"
          debug('request headers') { dump_headers env[:request_headers] }
          debug('request body') { env[:body].to_s }
          @app.call(env).on_complete do |environment|
            on_complete(environment)
          end
        end

        def on_complete(env)
          info('Status') { env[:status].to_s }
          debug('response headers') { dump_headers env[:response_headers] }
          debug('response body') { env[:body].to_s }
        end

        private

        def dump_headers(headers)
          headers.map { |k, v| "#{k}: #{v.inspect}" }.join("\n")
        end
      end
    end
  end
end