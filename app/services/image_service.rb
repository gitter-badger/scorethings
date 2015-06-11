class ImageService
  def search_image(query, size)
    cache_key = "ImageService.search_image(#{query}, #{size})"
    return Rails.cache.fetch(cache_key, expires_in: 2.day) do
      image_uris = []
      Google::Search::Image.new(query: query, image_size: size.to_sym).each do |image|
        image_uris << image.uri
      end
      Rails.cache.write(cache_key, image_uris)
      return image_uris
    end
  end
end