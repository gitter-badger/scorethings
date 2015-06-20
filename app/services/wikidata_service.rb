require 'wikidata/client'

class WikidataService
  def search(query)
    cache_key = "wikidata_service_search#{query})"

    cached_search_results = Rails.cache.fetch(cache_key, expires_in: 1.day) do
      response = Wikidata::Item.search(query)

      if response.empty?
        return []
      end

      search_results = response.results.map do |wikidata_item|
        map_item(wikidata_item)

      end

      Rails.cache.write(cache_key, search_results)
      return search_results
    end

    return cached_search_results
  end

  def find(wiki_data_item_id)
    cache_key = "wikidata_service_find#{wiki_data_item_id})"

    cached_wiki_data_item = Rails.cache.fetch(cache_key, expires_in: 1.day) do
      wiki_data_item = Wikidata::Item.find(wiki_data_item_id)

      if wiki_data_item.nil?
        raise Exceptions::WikidataItemNotFoundError
      end

      wiki_data_item = map_item(wiki_data_item)

      Rails.cache.write(cache_key, wiki_data_item)
      return wiki_data_item
    end

    return cached_wiki_data_item
  end

  private
  def map_item(wikidata_item)
    official_websites_values = wikidata_item.official_websites.map do |official_website|
      official_website.value
    end

    unless wikidata_item.descriptions.nil?
      wikidata_en_description = wikidata_item.descriptions.to_hash.fetch('en', {}).fetch('value', nil)
    end

    return {
        title: wikidata_item.title,
        id: wikidata_item.id,
        official_websites: official_websites_values,
        description: wikidata_en_description
    }
  end
end