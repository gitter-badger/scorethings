module Api
  module V1
    class DbpediaThingsController < ApplicationController
      skip_before_action :authenticate_request

      def show
        resource_name = params.require(:resource_name)
        begin
          @dbpedia_thing = $thing_service.find_from_dbpedia(resource_name)
          return render json: {
                            dbpedia_thing: @dbpedia_thing,
                            status: :ok
                        }, status: :ok
        rescue Exceptions::DbpediaThingNotFoundError
          return render json: {
                            error: "dbpedia thing not found",
                            status: :not_found
                        }, status: :not_found
        end
      end

      def search
        query = params.require(:query)
        @search_results = $thing_service.search(query)
        return render json: {
                          search_results: @search_results,
                          status: :ok
                      }, status: :ok
      end
    end
  end
end