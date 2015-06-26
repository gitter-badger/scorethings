module Api
  module V1
    class CriteriaController < ApplicationController
      skip_before_action :authenticate_request, :current_user, only: [:index]

      def index
        @criteria = Criterion.all
        return render json: {
                          criteria: @criteria,
                          status: :ok
                      }, status: :ok
      end
    end
  end
end