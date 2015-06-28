require 'rails_helper'

RSpec.describe ThingService do
  before do
    @thing_service = ThingService.new
  end

  describe "finding Patton Oswalt" do
    before do
      @thing = {
          title: 'Patton Oswalt',
          id: 'Q374065',
          official_websites: [
              'http://www.pattonoswalt.com/'
          ]
      }
    end

    it "should create a new thing" do
      expect_any_instance_of(WikidataService).to receive(:find).with('Q374065')
                                                  .and_return(@thing)

      expect(ScoredThing.all.length).to eq(0)
      @thing_service.find_scored_thing_or_create_from_thing('Q374065')
      expect(ScoredThing.all.length).to eq(1)
      expect(ScoredThing.all.first.thing_id).to eq('Q374065')
      expect(ScoredThing.all.first.title).to eq('Patton Oswalt')
    end

    it "should find a thing and not create from thing" do
      scored_thing = create(:scored_thing)
      expect(ScoredThing.all.length).to eq(1)
      thing = @thing_service.find_scored_thing_or_create_from_thing(scored_thing.thing_id)
      expect(ScoredThing.all.length).to eq(1)
      expect(thing).to eq(scored_thing)
    end
  end
end
