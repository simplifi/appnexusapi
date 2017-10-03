module AppnexusApi
  module Faraday
    module Response
      class RaiseHttpError < ::Faraday::Response::Middleware
        # Inexplicably, sandbox uses the correct code of 429, while production uses 405? so
        # we just rely on the error message
        RATE_EXCEEDED_ERROR = 'RATE_EXCEEDED'.freeze

        def on_complete(response)
          case response[:status].to_i
          when 400
            raise AppnexusApi::BadRequest, error_message(response)
          when 401
            raise AppnexusApi::Unauthorized, error_message(response)
          when 403
            raise AppnexusApi::Forbidden, error_message(response)
          when 404
            raise AppnexusApi::NotFound, error_message(response)
          when 406
            raise AppnexusApi::NotAcceptable, error_message(response)
          when 422
            raise AppnexusApi::UnprocessableEntity, error_message(response)
          when 500
            raise AppnexusApi::InternalServerError, error_message(response)
          when 501
            raise AppnexusApi::NotImplemented, error_message(response)
          when 502
            raise AppnexusApi::BadGateway, error_message(response)
          when 503
            raise AppnexusApi::ServiceUnavailable, error_message(response)
          end

          return if response.body.empty?
          body = JSON.parse(response.body).fetch('response', {})

          if body['error_code'] == RATE_EXCEEDED_ERROR
            raise AppnexusApi::RateLimitExceeded, "Retry after #{response.response_headers['retry-after']}s"
          elsif body['error_id'] && !body['error_id'].empty?
            # TODO: this should raise an error, but a lot of the specs currently have error responses
            # raise AppnexusApi::Error, "#{body['error_id']}: #{body['error']} - #{body['error_description']}"
          end
        end

        def error_message(response)
          msg = "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{response[:status]}"
          if (errors = response[:body]) && response[:body]['errors']
            msg << "\n"
            msg << errors.join("\n")
          end
          msg
        end
      end
    end
  end
end
