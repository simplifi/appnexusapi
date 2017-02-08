require 'spec_helper'

describe AppnexusApi::CreativeService do
  include_context 'with an advertiser'

  let(:creative_service) { described_class.new(connection) }
  let(:new_creative) do
    {
      'name'      => 'rspec test creative',
      'content'   => '<iframe src="helloword.html"></iframe>',
      'width'     => '300',
      'height'    => '250',
      'template'  => { 'id' => 7 }
    }
  end

  it 'respects the throttle limit', slow: true do
    # this spec will attempt to make 100 writes as fast as possible with 10
    # threads running in a loop of 10.  Typically you hit the limit right
    # around 25 seconds in.  If your connection is slow, this
    # test may never hit the throttle limit
    expect do
      # this runs so we only authenticate once instead of 10 times.
      _p = creative_service.get('num_elements' => 1, 'start_element' => 0)
      10.times do
        threads = []
        10.times do
          threads << Thread.new do
            creative = creative_service.create(advertiser_url_params, new_creative)
            puts creative.dbg_info
          end
        end
        threads.map(&:join)
      end
    end.to_not raise_error

    advertiser.delete
  end

  it 'supports a get operation' do
    VCR.use_cassette('creative_service_get') do
      expect { creative_service.get('start_element' => 0, 'num_elements' => 1) }.to_not raise_error
      advertiser.delete
    end
  end

  context 'creating a new creative' do
    it 'supports creating a new creative' do
      VCR.use_cassette('creative_service_create') do
        creative = creative_service.create(advertiser_url_params, new_creative)
        expect(creative.width).to eq(300)
        expect(creative.height).to eq(250)
        advertiser.delete
      end
    end
  end

  context 'an existing creative' do
    let(:existing_creative) { creative_service.create(advertiser_url_params, new_creative) }

    it 'supports changing attributes with the update action' do
      VCR.use_cassette('creative_service_update') do
        expect(existing_creative.code).to be_nil
        existing_creative.update(advertiser_url_params, code: "abc")
        expect(existing_creative.code).to eq "abc"
        advertiser.delete
      end
    end

    it 'supports removing the creative' do
      VCR.use_cassette('creative_service_delete') do
        id = existing_creative.id
        creative = creative_service.get('id' => id).first
        expect(creative.id).to eq id
        existing_creative.delete(advertiser_url_params)
        creative = creative_service.get('id' => id)
        expect(creative).to be_nil
        advertiser.delete
      end
    end
  end
end
