class ThingService
  def initialize
    @dbpedia_service = DbpediaService.new
  end

  def search(query)
    @dbpedia_service.search(query)
  end

  def find_from_dbpedia(resource_name)
    dbpedia_resource = @dbpedia_service.find(resource_name)
    if dbpedia_resource.nil?
      raise Exceptions::DbpediaThingNotFoundError
    else
      return dbpedia_resource
    end
  end

  def find_or_create_thing_from_dbpedia(resource_name)
    thing = Thing.where(resource_name: resource_name).first
    return thing unless thing.nil?

    dbpedia_resource = find_from_dbpedia(resource_name)

    thing = Thing.new(resource_name: dbpedia_resource[:resource_name], label: dbpedia_resource[:label])
    dbpedia_resource[:categories].each do |category|
      begin
        thing_category = ThingCategory.find_by(resource_name: category[:resource_name])
        thing.thing_categories << thing_category
      rescue Mongoid::Errors::DocumentNotFound
        thing.thing_categories << ThingCategory.new(resource_name: category[:resource_name], label: category[:label])
      end
    end

    thing.save!
    thing
  end

end