module Api
  module V1
    class ThingsController < ApplicationController
      skip_before_action :authenticate_request, :current_user, only: [:show, :web_thing]

      def create
        thing_params = params.require(:thing).permit(:type, :external_id)
        begin
          @thing = $thing_service.find_or_create_by_type_and_external_id(thing_params[:type], thing_params[:external_id])
          redirect_to action: 'show', id: @thing._id
        rescue Exceptions::WebThingNotFoundError
          return render json: {
                            error: "web_thing for thing was not found",
                            status: :not_found
                        }, status: :not_found
        end

      end

      def show
        thing_id = params.require(:id)
        begin
          @thing = Thing.find(thing_id)
          # FIXME change 'type' to a different name
          @web_thing = $thing_service.get_web_thing(@thing[:type], @thing[:external_id])
        rescue Mongoid::Errors::DocumentNotFound
          return render json: {
                            error: "thing was not found with id: #{thing_id}",
                            status: :not_found
                        }, status: :not_found
        rescue Exceptions::WebThingNotFoundError
          return render json: {
                            error: "web_thing was not found for thing with id: #{thing_id}",
                            status: :failed_dependency
                        }, status: :failed_dependency
        end
      end

      def web_thing
        id = params.require(:id)
        begin
          @thing = Thing.find(id)
          redirect_to controller: 'web_things', action: 'show', external_id: @thing[:external_id], type: @thing[:type]
        rescue Mongoid::Errors::DocumentNotFound
          return render json: {
                            error: "thing was not found with thing_id: #{id}",
                            status: :not_found
                        }, status: :not_found
        end
      end
    end
  end
end