class ImageService
  MAX_NUM_OF_IMAGES = 3

  def search_image(query)
    cache_key = "image_service.search_image(#{query})"
    return Rails.cache.fetch(cache_key, expires_in: 7.day) do
      image_uris = []
      # TODO figure out how to improve this, takes too long
      # TODO figure out how to only query for MAX_NUM_OF_IMAGES
      Google::Search::Image.new(query: query, image_size: :small).each do |image|
        image_uris << image.uri
      end
      image_uris = image_uris[0..MAX_NUM_OF_IMAGES-1]
      Rails.cache.write(cache_key, image_uris)
      return image_uris
    end
  end
end