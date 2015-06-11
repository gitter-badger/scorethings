module Api
  module V1
    class PotentialThingsController < ApplicationController
      skip_before_action :authenticate_request

      def show
        resource_name = params.require(:resource_name)
        begin
          @potential_thing = $thing_service.find(resource_name)
          @thing = Thing.where(resource_name: resource_name).first
        rescue Exceptions::PotentialThingNotFoundError
          return render json: {
                            error: "thing was not found with resource_name: #{resource_name}",
                            status: :not_found
                        }, status: :not_found
        end
      end

      def search
        @search_results = $thing_service.search(params.require(:query))
        return render json: {
                          search_results: @search_results,
                          status: :ok
                      }, status: :ok
      end

      def search_images
        query = params.require(:query)
        size = params.require(:size)
        @image_uris = $image_service.search_image(query, size)
        return render json: {
                          image_urls: @image_uris,
                          status: :ok
                      }, status: :ok
      end
    end
  end
end