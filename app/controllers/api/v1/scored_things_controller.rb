module Api
  module V1
    class ScoredThingsController < ApplicationController
      skip_before_action :authenticate_request, :current_user, only: [:show, :scores]

      def show
        begin
          @scored_thing = ScoredThing.find(params.require(:id))
          return render json: {
                            scored_thing: @scored_thing,
                            status: :ok
                        }, status: :ok
        rescue Mongoid::Errors::DocumentNotFound
          return render json: {
                            error: "scored thing was not found",
                            status: :not_found
                        }, status: :not_found
        end
      end

      def scores
        begin
          scored_thing = ScoredThing.find(params.require(:id))
          @scores = scored_thing.scores
        rescue Mongoid::Errors::DocumentNotFound
          return render json: {
                            error: "scored thing was not found",
                            status: :not_found
                        }, status: :not_found
        end
      end
    end
  end
end