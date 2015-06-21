require 'wikidata/client'

class WikidataService

  def search(query)
    cached_search_results = Rails.cache.fetch(wikidata_search_cache_key(query), expires_in: 1.hour) do
      response = Wikidata::Item.search(query)

      if response.empty?
        return []
      end

      search_results = response.results.map do |wikidata_item|
        map_item(wikidata_item)
      end

      search_results.each do |search_result|
        # write the wikidata item to cache, so when finding it, it hits cache (probably happens soon after search)
        Rails.cache.write(wikidata_item_cache_key(search_result[:id]), search_result, expires_in: 1.hour)
      end

      return search_results
    end

    return cached_search_results
  end

  def find(wikidata_item_id)
    cached_wikidata_item = Rails.cache.fetch(wikidata_item_cache_key(wikidata_item_id), expires_in: 1.hour) do
      full_wikidata_item = Wikidata::Item.find(wikidata_item_id)

      if full_wikidata_item.nil?
        raise Exceptions::WikidataItemNotFoundError
      end

      return map_item(full_wikidata_item)
    end

    return cached_wikidata_item
  end

  private
  def wikidata_item_cache_key(wikidata_item_id)
    "wikidata_item(#{wikidata_item_id})"
  end

  def wikidata_search_cache_key(query)
    "wikidata_search(#{query})"
  end

  def map_item(full_wikidata_item)
    official_websites_values = full_wikidata_item.official_websites.map do |official_website|
      official_website.value
    end

    unless full_wikidata_item.descriptions.nil?
      wikidata_en_description = full_wikidata_item.descriptions.to_hash.fetch('en', {}).fetch('value', nil)
    end

    return {
        title: full_wikidata_item.title,
        id: full_wikidata_item.id,
        official_websites: official_websites_values,
        description: wikidata_en_description
    }
  end
end