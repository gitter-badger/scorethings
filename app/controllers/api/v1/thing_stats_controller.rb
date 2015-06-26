module Api
  module V1
    class ThingStatsController < ApplicationController
      skip_before_action :authenticate_request, :current_user, only: [:show]

      def show
        begin
          thing_id = params.require(:id)
          criterion_id = params[:criterion_id]
          if criterion_id.nil?
            @thing_stats = $stats_service.thing_stats(thing_id)
          else
            @thing_stats = $stats_service.thing_stats_by_criterion(thing_id, criterion_id)
          end
          return render json: {
                            thing_stats: @thing_stats,
                            status: :ok
                        }, status: :ok
        rescue Mongoid::Errors::DocumentNotFound
          return render json: {
                            status: :not_found
                        }, status: :not_found
        end
      end
    end
  end
end