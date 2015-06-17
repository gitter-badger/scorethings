require 'rails_helper'

RSpec.describe ThingService do
  before do
    @thing_service = ThingService.new
  end

  describe "searching" do
    xit "should search for a thing" do
      expected_search_results = [
          DbpediaSearchResult.new(
              resource_name: 'Patton_Oswalt',
              label: 'Patton Oswalt',
              description: 'Big movie star.'),
          DbpediaSearchResult.new(
              resource_name: 'Matt_Oswalt',
              label: 'Matt Oswalt',
              description: 'Super funny comedian.')
      ]
      expect_any_instance_of(DbpediaService).to receive(:search).with('Patton Oswalt')
                                                          .and_return(expected_search_results)

      search_results = @thing_service.search('Patton Oswalt')

      expect(search_results).to_not be_nil
      expect(search_results).to eq(expected_search_results)
    end
  end

  describe "finding Patton Oswalt" do
    before do
      @dbpedia_resource = {
          resource_name: 'Patton_Oswalt',
          label: 'Patton Oswalt',
          categories: [
              {
                  label: 'American comics writers',
                  resource_name: 'Category:American_comics_writers'
              },
              {
                  label: 'Living people',
                  resource_name: 'Category:Living_people'
              }
          ]
      }

      puts "\t\t\THIS IS HAPPENNING"
      @existing_thing_categories = create_list(:thing_category, 2)
      @existing_thing = create(:thing,
                               resource_name: 'Patton_Oswalt',
                               thing_categories: @existing_thing_categories)
    end

    xit "should find" do
      expect_any_instance_of(DbpediaService).to receive(:find).with('Patton_Oswalt')
                                                   .and_return(@dbpedia_resource)

      result = @thing_service.find_from_dbpedia('Patton_Oswalt')
      expect(result).to eq(@dbpedia_resource)
    end

    xit "should raise exception when nothing found" do
      expect_any_instance_of(DbpediaService).to receive(:find).with('Patton_Oswalt')
                                                   .and_return(nil)
      expect {
        @thing_service.find_from_dbpedia('Patton_Oswalt')
      }.to raise_error(Exceptions::DbpediaThingNotFoundError)
    end

    end

    it "should create when finding or creating and thing doesn't exist in database" do
      expect_any_instance_of(DbpediaService).to receive(:find).with('Patton_Oswalt')
                                                   .and_return(@dbpedia_resource)

      expect(Thing.all.length).to eq(1)
      expect(ThingCategory.all.length).to eq(1)

      thing = @thing_service.find_or_create_thing_from_dbpedia('Patton_Oswalt')

      expect(Thing.all.length).to eq(2)
      expect(ThingCategory.all.length).to eq(4)

      expect(thing.label).to eq('Patton Oswalt')
      expect(thing.resource_name).to eq('Patton_Oswalt')
      expect(thing.thing_categories.length).to eq(2)
    end

    xit "should find when finding or creating and thing exists in database" do
      expect(Thing.all.length).to eq(1)
      expect(ThingCategory.all.length).to eq(1)
      thing = @thing_service.find_or_create_thing_from_dbpedia('Patton_Oswalt')
      expect(Thing.all.length).to eq(1)
      expect(ThingCategory.all.length).to eq(1)
      expect(thing).to eq(@existing_thing)
    end

    xit "should create with thing categories" do
      expect_any_instance_of(DbpediaService).to receive(:find).with('Patton_Oswalt')
                                                    .and_return(@dbpedia_resource)

      thing = @thing_service.find_or_create_thing_from_dbpedia('Patton_Oswalt')

    end
end
