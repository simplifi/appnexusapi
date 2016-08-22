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

  xit 'respects the throttle limit' do
    # this spec is purposefully disabled as it will create 100 new creatives as fast as possbile to bump up against
    # the write limits.  Run this spec at your own peril!  Also, running this spec more than once in a row will
    # bump up against your authorization limit of 10 per 300 seconds
    expect do
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

