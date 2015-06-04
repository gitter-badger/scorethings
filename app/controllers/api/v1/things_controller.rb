module Api
  module V1
    class ThingsController < ApplicationController
      skip_before_action :authenticate_request

      def show
        external_id = params.require(:external_id)
        type = params.require(:type)
        begin
          @thing = $thing_service.get_thing(type, external_id)
          @thing_reference = ThingReference.where(type: @thing.type, external_id: @thing.external_id).first
        rescue Exceptions::ThingNotFoundError
          return render json: {
                            error: "thing was not found with external_id: #{external_id} and type: #{type}",
                            status: :not_found
                        }, status: :not_found
        end
      end

      def search
        type = params.require(:type)
        query = params.require(:query)
        begin
          @thing_search_results = $thing_service.search_for_things(type, query)
        rescue Exceptions::ThingTypeUnknownError
          return render json: {
                            error: "unknown thing_reference type: #{type}",
                            status: :bad_request
                        }, status: :bad_request
        end
      end
    end
  end
end