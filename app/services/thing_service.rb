class ThingService
  def initialize
    @wikipedia_service = WikipediaService.new
  end

  def find(query)
    @wikipedia_service.find(query)
  end

  def find_thing_or_create_from_wikipedia(pageid, title)
    thing = Thing.where(pageid: pageid).first
    return thing unless thing.nil?

    wikipedia_page_info = @wikipedia_service.find(title)

    thing = Thing.build_from_wikipedia_page_info(wikipedia_page_info)
    wikipedia_page_info[:categories].each do |category|
      begin
        thing_category = ThingCategory.find_by(title: category)
        thing.thing_categories << thing_category
      rescue Mongoid::Errors::DocumentNotFound
        thing.thing_categories << ThingCategory.new(title: category)
      end
    end

    thing.save!
    thing
  end
end