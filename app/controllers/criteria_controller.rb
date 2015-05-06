class CriteriaController < ApplicationController
  # TODO allow unauthenticated read?
  skip_before_action :authenticate_request, only: [:index]

  def index
    if params[:system_provided]
      criteria = Criterion.where(system_provided: true)
    else
      criteria = Criterion.all
    end
    return render json: {
                      criteria: criteria,
                      status: :ok
                  }, status: :ok
  end
end
