require 'spec_helper'

describe AppnexusApi::ContentCategoryService do
  let(:ccs) { described_class.new(connection) }
  let(:name) { 'rspec_content_category' }
  let(:name_update) { name + '_part_2' }

  it 'cruds' do
    VCR.use_cassette('content_category_crud') do
      created = ccs.create({}, name: name)

      gotten = ccs.get(id: created.id).first
      expect(gotten.name).to eq(name)

      gotten.update({}, name: name_update)
      expect(ccs.get(id: created.id).first.name).to eq(name_update)

      gotten.delete({})
      expect(ccs.get(id: created.id)).to be_nil
    end
  end
end
