module Api
  module V1
    class ThingsController < ApplicationController
      skip_before_action :authenticate_request, :current_user, only: [:show]

      def show
        begin
          @thing = Thing.find(params.require(:id))
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