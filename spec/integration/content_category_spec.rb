require 'spec_helper'

describe 'AppNexus Content Category' do
  before(:all) do
    @connection = connection
    @ccs = AppnexusApi::ContentCategoryService.new(@connection)
  end

  #I swear this used to work...
  #it 'default categories' do
  #  expect(@ccs.get(is_system: true)).not_to be_empty
  #end

  it "crud" do
    ts = "_#{Time.now.to_i}"
    created = @ccs.create({}, name: "rspec" + ts)

    gotten = @ccs.get(id: created.id).first
    expect(gotten.name).to eq "rspec" + ts

    gotten.update({}, name: "rspec2" + ts)
    expect(@ccs.get(id: created.id).first.name).to eq "rspec2" + ts

    gotten.delete({})
    expect(@ccs.get(id: created.id)).to be_nil
  end

end
