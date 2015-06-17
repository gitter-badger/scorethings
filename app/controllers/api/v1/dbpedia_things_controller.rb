module Api
  module V1
    class DbpediaThingsController < ApplicationController
      skip_before_action :authenticate_request

      def show
        resource_name = params.require(:resource_name)
        begin
          @dbpediaThing = $thing_service.find_from_dbpedia(resource_name)
          return render json: {
                            dbpediaThing: @dbpediaThing,
                            status: :ok
                        }, status: :ok
        rescue Exceptions::DbpediaThingNotFoundError
          return render json: {
                            error: "thing was not found with resource_name: #{resource_name}",
                            status: :not_found
                        }, status: :not_found
        end
      end

      def search
        @dbpedia_search_results = $thing_service.search(params.require(:query))
        return render json: {
                          search_results: @dbpedia_search_results,
                          status: :ok
                      }, status: :ok
      end
    end
  end
end