module Api
  module V1
    class ScoreListsController < ApplicationController
      skip_before_action :authenticate_request, only: [:show]

      def create
        score_list_params = params.require(:score_list).permit(:name)
        begin
          @score_list = @current_user.create_score_list(score_list_params)
          render template: '/api/v1/score_lists/create.jbuilder', status: :created, formats: [:json]
        rescue Mongoid::Errors::Validations => error
          return render json: {
                            error: "invalid: #{error}",
                            status: :bad_request
                        }, status: :bad_request
        end
      end

      def update
        @score_list = ScoreList.where(id: params[:id]).first
        if @score_list.nil?
          return render json: {
                            error: "failed to score_list for id: #{params[:id]}",
                            status: :not_found
                        }, status: :not_found
        end

        begin
          score_list_params = params.require(:score_list).permit(:name)
          @current_user.change_score_list(@score_list, score_list_params)
        rescue Exceptions::UnauthorizedModificationError
          return render json: {
                            error: "failed to change score_list for id: #{params[:id]}",
                            status: :forbidden
                        }, status: :forbidden
        end
      end

      def destroy
        @score_list = ScoreList.where(id: params[:id]).first
        if @score_list.nil?
          return render json: {
                            error: "failed to score_list for id: #{params[:id]}",
                            status: :not_found
                        }, status: :not_found
        end
        begin
          @current_user.delete_score_list(@score_list)
          return render json: {
                            status: :ok
                        }, status: :ok
        rescue Exceptions::UnauthorizedModificationError
          return render json: {
                            error: "failed to delete score_list for id: #{params[:id]}",
                            status: :forbidden
                        }, status: :forbidden
        end
      end

      def show
        @score_list = ScoreList.where(id: params[:id]).first
        if @score_list.nil?
          return render json: {
                            error: "failed to score_list for id: #{params[:id]}",
                            status: :not_found
                        }, status: :not_found
        end
      end
   end
  end
end
