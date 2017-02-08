require 'spec_helper'

describe AppnexusApi::PublisherService do
  include_context 'with a publisher'

  it "cruds" do
    VCR.use_cassette('publisher_crud') do
      expect(publisher.name).to eq 'spec publisher'
      expect(publisher.expose_domains).to be true
      expect(publisher.reselling_exposure).to eq "public"
      expect(publisher.ad_quality_advanced_mode_enabled).to be true

      expect { publisher_service.get("id" => publisher.id) }.to_not raise_error

      publisher.delete

      expect(publisher_service.get("id" => publisher.id)).to be_nil
    end
  end
end
