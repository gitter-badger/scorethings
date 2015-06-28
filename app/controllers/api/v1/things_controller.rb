module Api
  module V1
    class ThingsController < ApplicationController
      skip_before_action :authenticate_request

      def find
        thing_id = params.require(:thing_id)
        begin
          @thing = $thing_service.find(thing_id)
        rescue Exceptions::ThingNotFoundError
          return render json: {
                            message: "could not find thing",
                            status: :not_found
                        }, status: :not_found
        end
        return render json: {
                          thing: @thing,
                          status: :ok
                      }, status: :ok
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