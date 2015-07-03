require 'wikidata/client'

class WikidataService

  def search(query)
    # search wikidata items and return the search results of things
    cached_search_results = Rails.cache.fetch(thing_search_cache_key(query), expires_in: 1.day) do
      response = Wikidata::Item.search(query)

      if response.empty?
        return []
      end

      search_results = response.results.map do |wikidata_item|
        map_wikidata_item_to_thing(wikidata_item)
      end

      search_results.each do |search_result|
        # write the wikidata item to cache, so when finding it, it hits cache (probably happens soon after search)
        Rails.cache.write(thing_cache_key(search_result[:id]), search_result, expires_in: 1.day)
      end

      Rails.cache.write(thing_search_cache_key(query), search_results, expires_in: 1.day)

      return search_results
    end

    return cached_search_results
  end

  def find(thing_id)
    # find a wikidata item by it's id, return that wikidata item mapped to a thing
    cached_thing = Rails.cache.fetch(thing_cache_key(thing_id), expires_in: 1.day) do
      wikidata_item = Wikidata::Item.find(thing_id)

      if wikidata_item.nil?
        raise Exceptions::ThingNotFoundError
      end

      thing = map_wikidata_item_to_thing(wikidata_item)
      Rails.cache.write(thing_cache_key(thing_cache_key(thing_id)), thing, expires_in: 1.day)

      return thing
    end

    return cached_thing
  end

  private
  def thing_cache_key(wikidata_item_id)
    "thing(#{wikidata_item_id})"
  end

  def thing_search_cache_key(query)
    "thing_search(#{query})"
  end

  def map_wikidata_item_to_thing(full_wikidata_item)
    official_websites_values = full_wikidata_item.official_websites.map do |official_website|
      official_website.value
    end

    instance_of_values = full_wikidata_item.instance_of.map do |instance_of|
      instance_of.title
    end

    unless full_wikidata_item.descriptions.nil?
      wikidata_en_description = full_wikidata_item.descriptions.to_hash.fetch('en', {}).fetch('value', nil)
    end

    return {
        title: full_wikidata_item.title,
        id: full_wikidata_item.id,
        official_websites: official_websites_values,
        instance_of_values: instance_of_values,
        description: wikidata_en_description
    }
  end
end