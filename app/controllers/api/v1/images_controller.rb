module Api
  module V1
    class ImagesController < ApplicationController
      skip_before_action :authenticate_request

      def search
        query = params.require(:query)
        @image_uris = $image_service.search_image(query)
        return render json: {
                          image_urls: @image_uris,
                          status: :ok
                      }, status: :ok
      end
    end
  end
end