module Api
  module V1
    class ThingReferencesController < ApplicationController
      skip_before_action :authenticate_request, :current_user, only: [:show]

      def create
        thing_params = params.require(:thing_reference).permit(:type, :external_id)
        begin
          @thing_reference = $thing_service.find_or_create_thing_reference_to_thing(thing_params[:type], thing_params[:external_id])
          redirect_to action: 'show', id: @thing_reference._id
        rescue Exceptions::ThingNotFoundError
          return render json: {
                            error: "thing for thing_reference was not found",
                            status: :not_found
                        }, status: :not_found
        end

      end

      def show
        thing_reference_id = params.require(:id)
        begin
          @thing_reference = ThingReference.find(thing_reference_id)
          # FIXME change 'type' to a different name
          @thing = $thing_service.get_thing(@thing_reference[:type], @thing_reference[:external_id])
        rescue Mongoid::Errors::DocumentNotFound
          return render json: {
                            error: "thing_reference was not found with id: #{thing_reference_id}",
                            status: :not_found
                        }, status: :not_found
        rescue Exceptions::ThingNotFoundError
          return render json: {
                            error: "thing was not found for thing_reference with id: #{thing_reference_id}",
                            status: :failed_dependency
                        }, status: :failed_dependency
        end
      end
    end
  end
end