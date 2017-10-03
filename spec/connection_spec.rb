require 'spec_helper'

describe AppnexusApi::Connection do
  let(:connection_with_null_logger) { AppnexusApi::Connection.new(connection_params) }

  subject do
    connection = described_class.new({})
    connection.logger.level = Logger::FATAL
    connection
  end

  it 'allows no logger to be specified' do
    expect { AppnexusApi::CreativeService.new(connection_with_null_logger) }.to_not raise_error
  end

  context 'retries' do
    let(:reponse_data) { { not_an_error: 1 } }

    it 'returns data from expiration' do
      #stub to raise error the first time and then return []
      counter = 0
      expect(subject).to receive(:login)
      expect(subject.connection).to receive(:run_request).twice do |arg|
        counter += 1
        raise AppnexusApi::Unauthorized.new if counter == 1
        Faraday::Response.new(body: reponse_data)
      end

      expect(subject.get('http://localhost', {}, {}).body).to eq(reponse_data)
    end

    context 'rate limited errors' do
      let(:response) do
        Faraday::Response.new(
          status: 405,
          body: { 'error_code' => AppnexusApi::Faraday::Response::RaiseHttpError::RATE_EXCEEDED_ERROR },
          response_headers: { 'retry-after' => 15 }
        )
      end

      before do
        described_class.const_set('RATE_EXCEEDED_DEFAULT_TIMEOUT', 0)
      end

      it 'retries 3 times' do
        expect(subject).to receive(:login)

        counter = 0
        expect(subject.connection).to receive(:run_request).exactly(3).times do |arg|
          raise AppnexusApi::RateLimitExceeded, 'Retry after 0s'
        end

        expect { subject.get('http://localhost', {}, {}).body }.to raise_error(AppnexusApi::RateLimitExceeded)
      end
    end
  end
end
