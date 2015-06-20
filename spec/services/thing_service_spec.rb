require 'rails_helper'

RSpec.describe ThingService do
  before do
    @thing_service = ThingService.new
  end

  describe "finding Patton Oswalt" do
    before do
      @wikidata_item = {
          title: 'Patton Oswalt',
          id: 'Q374065',
          official_websites: [
              'http://www.pattonoswalt.com/'
          ]
      }
    end

    it "should create a new thing" do
      expect_any_instance_of(WikidataService).to receive(:find).with('Q374065')
                                                  .and_return(@wikidata_item)

      expect(Thing.all.length).to eq(0)
      @thing_service.find_thing_or_create_from_wikidata('Q374065')
      expect(Thing.all.length).to eq(1)
      expect(Thing.all.first.wikidata_item_id).to eq('Q374065')
      expect(Thing.all.first.title).to eq('Patton Oswalt')
    end

    it "should find a thing and not create from wikidata" do
      existing_thing = create(:thing)
      expect(Thing.all.length).to eq(1)
      thing = @thing_service.find_thing_or_create_from_wikidata(existing_thing.wikidata_item_id)
      expect(Thing.all.length).to eq(1)
      expect(thing).to eq(existing_thing)
    end
  end
end
