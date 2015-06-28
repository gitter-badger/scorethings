class ThingService
  def initialize
    @wikidata_service = WikidataService.new
  end

  def find(thing_id)
    @wikidata_service.find(thing_id)
  end

  def search(query)
    @wikidata_service.search(query)
  end

  def find_scored_thing_or_create_from_thing(thing_id)
    scored_thing = ScoredThing.where(thing_id: thing_id).first
    return scored_thing unless scored_thing.nil?

    # if wikidata doesn't have it, error should be raised
    thing = @wikidata_service.find(thing_id)

    scored_thing = ScoredThing.build_from_thing(thing)
    scored_thing.save!
    scored_thing
  end
end