require 'spec_helper'

describe "payment rule service" do
  before(:all) do
    @connection = connection
    @payment_rule_service   = AppnexusApi::PaymentRuleService.new(@connection)

    @code = "spec_payment_rule_code_#{Time.now.to_i}_#{rand(9_000_000)}"
    @publisher_service = AppnexusApi::PublisherService.new(@connection)
    code = @code
    new_publisher_url_params = { create_default_placement: false }
    new_publisher_params = {
      name: "spec payment rule publisher",
      code: code,
      expose_domains: true,
      reselling_exposure: "public",
      ad_quality_advanced_mode_enabled: true
    }

    @publisher = @publisher_service.create(new_publisher_url_params,
                                           new_publisher_params)
  end

  after(:all) do
    @publisher.delete
  end

  it "payment rule life cycle" do
    # create a payment rule
    url_params = {
      :publisher_id => @publisher["id"]
    }
    params = {
      :code => @code,
      :name => "spec payment rule",
      :pricing_type => "cpm",
      :cost_cpm => 1.00,
    }

    payment_rule = @payment_rule_service.create(url_params, params)
    payment_rule.name.should == "spec payment rule"
    payment_rule.cost_cpm.should == 1.00

    updated_rule = payment_rule.update(url_params, {cost_cpm: 2.00} )
    updated_rule["cost_cpm"].should == 2.00

    # delete the payment rule
    payment_rule.delete
  end
end
