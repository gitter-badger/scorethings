module Api
  module V1
    class ThingController < ApplicationController
      skip_before_action :authenticate_request, :current_user, only: [:show]

      def create
        thing_params = params.require(:thing).permit(:resource_name)
        begin
          @thing = ThingService.find_or_create_by_resource_name(thing_params[:resource_name])
          return render json: {
                            thing: @thing.to_builder,
                            status: :created
                        }, status: :created
        rescue Exceptions::DbpediaThingNotFoundError
          return render json: {
                            error: "thing for thing was not found",
                            status: :not_found
                        }, status: :not_found
        end

      end

      def show
        begin
          @thing = Thing.find(params.require(:id))
          return render json: {
                            thing: @thing.to_builder,
                            status: :ok
                        }, status: :ok
        rescue Mongoid::Errors::DocumentNotFound
          return render json: {
                            error: "thing was not found",
                            status: :not_found
                        }, status: :not_found
        end
      end
    end
  end
end