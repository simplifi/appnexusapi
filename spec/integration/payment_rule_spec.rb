require 'spec_helper'

describe AppnexusApi::PaymentRuleService do
  include_context 'with a publisher'

  let(:payment_rule_service) { described_class.new(connection) }
  let(:code) { 'spec_payment_rule_code' }
  let(:payment_rules_url_params) { { publisher_id: publisher['id'] } }
  let(:initial_cost_cpm) { 1.00 }
  let(:update_cost_cpm) { 2.00 }
  let(:payment_rule_params) do
    {
      code: code,
      name: 'spec payment rule',
      pricing_type: 'cpm',
      cost_cpm: initial_cost_cpm
    }
  end

  it 'payment rule life cycle' do
    VCR.use_cassette('payment_rule_lifecycle') do
      payment_rule = payment_rule_service.create(payment_rules_url_params, payment_rule_params)
      expect(payment_rule.name).to eq('spec payment rule')
      expect(payment_rule.cost_cpm).to eq(initial_cost_cpm)

      updated_rule = payment_rule.update(payment_rules_url_params, { cost_cpm: update_cost_cpm} )
      expect(updated_rule['cost_cpm']).to eq(update_cost_cpm)

      payment_rule.delete
      publisher.delete
    end
  end
end
