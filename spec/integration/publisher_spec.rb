require 'spec_helper'

describe "AppNexus Publisher" do
  before(:all) do
    @connection = connection
    @publisher_service = AppnexusApi::PublisherService.new(@connection)
  end

  it "publisher life cycle" do
    code = "spec_code_#{Time.now.to_i}_#{rand(9_000_000)}"
    new_publisher_params = {
      name: "Publisher Name",
      code: code,
      expose_domains: true,
      reselling_exposure: "public",
      ad_quality_advanced_mode_enabled: true
    }

    publisher = @publisher_service.create({}, new_publisher_params)
    publisher.name.should == "Publisher Name"
    publisher.code.should == code
    publisher.expose_domains.should == true
    publisher.reselling_exposure.should == "public"
    publisher.ad_quality_advanced_mode_enabled.should == true


    expect { @publisher_service.get("id" => publisher.id) }.to_not raise_error

    publisher.delete

    expect { @publisher_service.get("id" => publisher.id) }.to raise_error(AppnexusApi::UnprocessableEntity)
  end
end
