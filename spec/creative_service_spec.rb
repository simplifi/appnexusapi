require 'spec_helper'

describe AppnexusApi::CreativeService do

  let(:creative_service) { AppnexusApi::CreativeService.new(connection, ENV['APPNEXUS_MEMBER_ID']) }
  let(:new_creative) {
    {
      "campaign"  => "default campaign",
      "content"   => "<iframe src='helloword.html'></iframe>",
      "width"     => "300",
      "height"    => "250",
      "template"  =>{ "id" => 7 }
    }
  }

  it 'respects the throttle limit' do
    # this spec will attempt to make 100 writes as fast as possible with 10 threads running in a loop
    # of 10.  Typically you hit the limit right around 25 seconds in.  If your connection is slow, this
    # test may never hit the throttle limit
    expect do
      # this runs so we only authenticate once instead of 10 times.
      _prime_the_pump = creative_service.get('num_elements' => 1, 'start_element' => 0)
      10.times do
        threads = []
        10.times do
          threads << Thread.new do
            creative = creative_service.create(new_creative)
            puts creative.dbg_info
          end
        end
        threads.map(&:join)
      end
    end.to_not raise_error
  end

  it 'supports a get operation' do
    expect {
      creative_service.get("start_element" => 0, "num_elements" => 1)
    }.to_not raise_error
  end

  context "creating a new creative" do
    it 'supports creating a new creative' do
      creative = creative_service.create(new_creative)
      expect(creative.width).to eq 300
      expect(creative.height).to eq 250
    end
  end

  context "an existing creative" do
    let(:existing_creative) { creative_service.create(new_creative) }

    it 'supports changing attributes with the update action' do
      expect(existing_creative.campaign).to eq "default campaign"
      existing_creative.update("campaign" => "My Best Campaign Yet")
      expect(existing_creative.campaign).to eq "My Best Campaign Yet"
    end

    it 'supports removing the creative' do
      id = existing_creative.id
      creative = creative_service.get("id" => id).first
      expect(creative.id).to eq id
      existing_creative.delete
      creative = creative_service.get("id" => id)
      expect(creative).to be_nil
    end
  end
end

