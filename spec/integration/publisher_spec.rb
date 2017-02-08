require 'spec_helper'

describe AppnexusApi::PublisherService do
  let(:publisher_service) { described_class.new(connection) }

  it "cruds" do
    code = "spec_code"
    new_publisher_params = {
      name: "Publisher Name",
      code: code,
      expose_domains: true,
      reselling_exposure: "public",
      ad_quality_advanced_mode_enabled: true
    }

    VCR.use_cassette('publisher_crud') do
      publisher = publisher_service.create({}, new_publisher_params)
      expect(publisher.name).to eq "Publisher Name"
      expect(publisher.code).to eq code
      expect(publisher.expose_domains).to be true
      expect(publisher.reselling_exposure).to eq "public"
      expect(publisher.ad_quality_advanced_mode_enabled).to be true

      expect { publisher_service.get("id" => publisher.id) }.to_not raise_error

      publisher.delete

      expect(publisher_service.get("id" => publisher.id)).to be_nil
    end
  end
end
