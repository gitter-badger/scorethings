module Api
  module V1
    class WebThingsController < ApplicationController
      skip_before_action :authenticate_request

      def show
        external_id = params.require(:external_id)
        type = params.require(:type)
        begin
          @web_thing = $thing_service.get_web_thing(type, external_id)
          @thing = Thing.where(type: @web_thing.type, external_id: @web_thing.external_id).first
        rescue Exceptions::WebThingNotFoundError
          return render json: {
                            error: "web_thing was not found with external_id: #{external_id} and type: #{type}",
                            status: :not_found
                        }, status: :not_found
        end
      end

      def search
        type = params.require(:type)
        query = params.require(:query)
        begin
          @web_thing_search_results = $thing_service.search_for_web_things(type, query)
        rescue Exceptions::ThingTypeUnknownError
          return render json: {
                            error: "unknown thing type: #{type}",
                            status: :bad_request
                        }, status: :bad_request
        end
      end
    end
  end
end