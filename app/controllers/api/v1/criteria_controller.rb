module Api
  module V1
    class CriteriaController < ApplicationController
      # TODO allow unauthenticated read?
      skip_before_action :authenticate_request, only: [:index]

      def index
        if params[:system_provided]
          criteria = Criterion.where(system_provided: true)
        elsif params[:user_id]
          criteria = Criterion.where(system_provided: false, user: params[:user_id])
        else
          criteria = Criterion.all
        end
        return render json: {
                          criteria: criteria,
                          status: :ok
                      }, status: :ok
      end
    end
  end
end