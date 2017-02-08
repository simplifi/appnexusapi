require 'spec_helper'

describe AppnexusApi::LineItemService do
  include_context 'with a new line item'

  it "line item life cycle" do
    # get all the line items
    VCR.use_cassette('line_item_life_cycle') do
      line_items = line_item_service.get(advertiser_id: advertiser_id)
      new_line_item = line_item_service.create(advertiser_url_params, line_item_params)

      ids = line_items.map(&:id) + [new_line_item.id]
      expect(line_item_service.get(advertiser_id: advertiser_id).map(&:id).sort).to eq(ids.sort)

      # update a line item
      expect(new_line_item.state).to eq("active")
      updated_line_item = new_line_item.update(advertiser_url_params, {state: "inactive"} )
      expect(updated_line_item["state"]).to eq('inactive')

      # delete a line item
      new_line_item.delete(advertiser_url_params)

      expect(line_item_service.get("id" => new_line_item.id)).to be_nil
      advertiser.delete
    end
  end
end
