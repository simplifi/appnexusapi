require 'spec_helper'

describe "line items" do
  before(:all) do
    @connection = connection
    @advertiser_id = 11510
    @line_item_service = AppnexusApi::LineItemService.new(@connection)
  end

  it "line item life cycle" do

    # get all the line items
    @line_items = @line_item_service.get(advertiser_id: @advertiser_id)

    # create a new line item
    new_line_item_url_params = {
      :advertiser_id => @advertiser_id
    }

    new_line_item_params = {
      name: "some line item #{rand(100_000)}",
      code: "spec_line_code_#{rand(100_000)}"
    }

    new_line_item = @line_item_service.create new_line_item_url_params, new_line_item_params
    ids = @line_items.map(&:id)
    ids << new_line_item.id
    @line_item_service.get(advertiser_id: @advertiser_id).map(&:id).sort.should == ids.sort

    # update a line item
    new_line_item.state.should == "active"
    updated_line_item = new_line_item.update({advertiser_id: @advertiser_id}, {state: "inactive"} )
    updated_line_item["state"].should == "inactive"

    # delete a line item
    new_line_item.delete({"advertiser_id" => @advertiser_id})

    expect { @line_item_service.get("id" => new_line_item.id) }.to raise_error(AppnexusApi::UnprocessableEntity)
  end
end
