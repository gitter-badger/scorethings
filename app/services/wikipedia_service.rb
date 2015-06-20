require 'wikipedia'

class WikipediaService
  def initialize
    @client = Wikipedia::Client.new
  end

  def find(title)
    cache_key = "wikipedia_service_search#{title})"

    cached_wikipedia_page_info = Rails.cache.fetch(cache_key, expires_in: 1.day) do
      wikipedia_page = @client.find(title, prop: ["info", "images", "categories"])

      wikipedia_pageid = wikipedia_page.page['pageid']
      if wikipedia_pageid.nil?
        raise Exceptions::WikipediaPageInfoNotFoundError
      end

      wikipedia_page_info = {
        pageid: wikipedia_pageid,
        image_urls: wikipedia_page.image_urls || [],
        title: wikipedia_page.title,
        full_url: wikipedia_page.page['fullurl'],
        categories: wikipedia_page.categories || []
      }

      Rails.cache.write(cache_key, wikipedia_page_info)
      return wikipedia_page_info
    end

    return cached_wikipedia_page_info
  end
end