module Api
  module V1
    class ThingImagesController < ApplicationController
      skip_before_action :authenticate_request

      def show
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