require 'rails_helper'

RSpec.describe ThingService do
  before do
    @thing_service = ThingService.new
  end

  describe "finding Patton Oswalt" do
    before do
      @wikipedia_page_info = {
          pageid: 1234,
          image_urls: [
              'https://upload.wikimedia.org/wikipedia/image1.jpg',
              'http://images.fandango.com/image2.jpg'
          ],
          title: 'Patton Oswalt',
          full_url: 'https://en.wikipedia.org/wiki/Patton_Oswalt',
          categories: [
            'Category:Characters created by Bob Kane',
            'Category:Mayors_of_Burlington,_Vermont'
          ]
      }
    end

    it "should create a new thing" do
      expect_any_instance_of(WikipediaService).to receive(:find).with('Patton Oswalt')
                                                  .and_return(@wikipedia_page_info)

      expect(Thing.all.length).to eq(0)
      expect(ThingCategory.all.length).to eq(0)
      @thing_service.find_thing_or_create_from_wikipedia(1234, 'Patton Oswalt')
      expect(Thing.all.length).to eq(1)
      expect(ThingCategory.all.length).to eq(2)
      expect(Thing.all.first.pageid).to eq(@wikipedia_page_info[:pageid])
      expect(Thing.all.first.image_urls).to eq(@wikipedia_page_info[:image_urls])
    end

    it "should create a new thing with existing thing categories" do
      expect_any_instance_of(WikipediaService).to receive(:find).with('Patton Oswalt')
                                                      .and_return(@wikipedia_page_info)

      create(:thing_category, title: @wikipedia_page_info[:categories].first)
      expect(ThingCategory.all.length).to eq(1)

      @thing_service.find_thing_or_create_from_wikipedia(1234, 'Patton Oswalt')
      expect(ThingCategory.all.length).to eq(2)
    end

    it "should find a thing" do
      existing_thing = create(:thing)
      expect(Thing.all.length).to eq(1)
      thing = @thing_service.find_thing_or_create_from_wikipedia(existing_thing.pageid,
                                                                 existing_thing.title)
      expect(Thing.all.length).to eq(1)
      expect(thing).to eq(existing_thing)
    end
  end
end
