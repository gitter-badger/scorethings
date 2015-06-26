module Api
  module V1
    class StatsController < ApplicationController
      skip_before_action :authenticate_request, :current_user, only: [:index]

      def index
        begin
          thing_id = params[:thing_id]
          criterion_id = params[:criterion_id]
          user_id = params[:user_id]

          filters = {}

          unless thing_id.nil?
            filters[:thing] = Thing.find(thing_id)
          end

          unless criterion_id.nil?
            filters[:criterion] = Criterion.find(criterion_id)
          end

          unless user_id.nil?
            filters[:user] = User.find(user_id)
          end

          @stats = $stats_service.get_score_stats(filters)

          return render json: {
                            stats: @stats,
                            status: :ok
                        }, status: :ok
        rescue Mongoid::Errors::DocumentNotFound => e
          error = e.message.to_s
          puts error
          return render json: {
                            error: error,
                            status: :not_found
                        }, status: :not_found
        end
      end
    end
  end
end