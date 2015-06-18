module Api
  module V1
    class ThingsController < ApplicationController
      skip_before_action :authenticate_request, :current_user, only: [:show]

      def create
        thing_params = params.require(:thing).permit(:resource_name)
        begin
          @thing = $thing_service.find_or_create_thing_from_dbpedia(thing_params[:resource_name])
          return render json: {
                            thing: @thing,
                            status: :created
                        }, status: :created
        rescue Exceptions::DbpediaThingNotFoundError
          return render json: {
                            error: "thing was not found",
                            status: :not_found
                        }, status: :not_found
        end

      end

      def show
        begin
          @thing = Thing.find_by(resource_name: params.require(:resource_name))
          return render json: {
                            thing: @thing,
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