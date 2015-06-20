class ThingService
  def initialize
    @wikidata_service = WikidataService.new
  end

  def find(wikidata_item_id)
    @wikidata_service.find(wikidata_item_id)
  end

  def search(query)
    @wikidata_service.search(query)
  end

  def find_thing_or_create_from_wikidata(wikidata_item_id)
    thing = Thing.where(wikidata_item_id: wikidata_item_id).first
    return thing unless thing.nil?

    # if wikidata doesn't have it, error should be raised
    wikipedia_page_info = @wikidata_service.find(wikidata_item_id)

    thing = Thing.build_from_wikidata_item(wikipedia_page_info)
    thing.save!
    thing
  end
end