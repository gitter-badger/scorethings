module Api
  module V1
    class CriteriaController < ApplicationController
      # TODO allow unauthenticated read?
      skip_before_action :authenticate_request, :current_user, only: [:system]

      def system
        @system_criteria = Criterion.where(system_provided: true)
      end
    end
  end
end