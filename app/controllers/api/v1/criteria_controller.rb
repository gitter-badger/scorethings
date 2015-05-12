module Api
  module V1
    class CriteriaController < ApplicationController
      # TODO allow unauthenticated read?
      skip_before_action :authenticate_request, :current_user, only: [:system]

      def system
        @system_criteria = Criterion.where(system_provided: true)
      end

      def create
        criterion = params.require(:criterion).permit(:name, :definition, :sign)
        @criterion = @current_user.create_criterion(criterion)
        render template: '/api/v1/criteria/create.jbuilder', status: :created, format: [:json]
      end
    end
  end
end