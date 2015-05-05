class CriteriaController < ApplicationController
  # TODO allow unauthenticated read?
  skip_before_action :authenticate_request, only: [:index]

  def index
    criteria = Criterion.all
    return render json: {
                      criteria: criteria,
                      status: :ok
                  }, status: :ok
  end
end

