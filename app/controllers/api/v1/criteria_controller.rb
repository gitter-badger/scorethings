module Api
  module V1
    class CriteriaController < ApplicationController
      # TODO allow unauthenticated read?
      skip_before_action :authenticate_request, only: [:system]

      def system
        criteria = Criterion.where(system_provided: true)
        return render json: {
                          criteria: criteria,
                          status: :ok
                      }, status: :ok
      end
    end
  end
end