module Api
  module V1
    class ScoresController < ApplicationController
      skip_before_action :authenticate_request, :current_user, only: [:search, :show, :valid_criteria]

      def valid_criteria
        return render json: {
                          valid_criteria: Score.valid_criteria,
                          status: :ok
                      }, status: :ok
      end

      def search
        # TODO add pagination when necessary
        query = params[:query]
        if query.nil?
          # TODO maybe require filter if ever too many scores
          return @scores = Score.all.to_a
        end

        parsed_search_query = parse_search_query(query)

        if parsed_search_query[:username].nil?
          return @scores = Score.full_text_search(parsed_search_query[:non_username_query_terms], allow_empty_search: true).to_a
        else
          begin
            user = User.find_by(username: parsed_search_query[:username])
            return @scores = user.scores.full_text_search(parsed_search_query[:non_username_query_terms], allow_empty_search: true).to_a
          rescue Mongoid::Errors::DocumentNotFound
            return render json: {
                              error: "user with username #{parsed_search_query[:username]} was not found",
                              status: :not_found
                          }, status: :not_found
          end
        end
      end

      def create
        score_params = params.require(:score).permit(:points, :criterion, thing: [:wikidata_item_id])

        begin
          thing = $thing_service.find_thing_or_create_from_wikidata(score_params[:thing][:wikidata_item_id])
          score_params[:thing] = thing

          @score = Score.new(score_params)
          @current_user.create_score(@score)
          return render json: {
                            score: @score,
                            status: :created
                        }, status: :created
        rescue Exceptions::ScoreNotUniqueError => e
          @existing_score = e.existing_score
          return render json: {
                            error: "New score conflicts with existing score.  You should update points instead.",
                            existing_score: @existing_score,
                            status: :conflict
                        }, status: :conflict
        rescue Mongoid::Errors::DocumentNotFound
          return render json: {
                            status: :not_found
                        }, status: :not_found
        rescue Exceptions::WikidataItemNotFoundError
          return render json: {
                            status: :not_found
                        }, status: :not_found
        rescue Mongoid::Errors::Validations
          return render json: {
                            error: "failed to create score: #{@score.errors.full_messages}",
                            status: :bad_request
                        }, status: :bad_request
        end
      end

      def update
        begin
          @score = Score.find(params.require(:id))
          score_params = params.require(:score).permit(:points)
          @current_user.update_points(@score, score_params[:points])
          return render json: {
                            score: @score,
                            status: :ok
                        }, status: :ok
        rescue Mongoid::Errors::DocumentNotFound
          return render json: {
                            status: :not_found
                        }, status: :not_found
        rescue Exceptions::UnauthorizedModificationError
          return render json: {
                            error: "unauthorized, cannot update score",
                            status: :forbidden
                        }, status: :forbidden
        rescue Mongoid::Errors::Validations
          return render json: {
                            error: "failed to update score: #{@score.errors.full_messages}",
                            status: :bad_request
                        }, status: :bad_request
        end
      end

      def destroy
        id = params.require(:id)
        begin
          score = Score.find(id)
          @current_user.delete_score(score)
          return render json: {
                            status: :ok
                        }, status: :ok
        rescue Mongoid::Errors::DocumentNotFound
          return render json: {
                            error: "failed to score for id: #{id}",
                            status: :not_found
                        }, status: :not_found
        rescue Exceptions::UnauthorizedModificationError
          return render json: {
                            error: "failed to delete score for id: #{id}",
                            status: :forbidden
                        }, status: :forbidden
        end
      end

      def show
        id = params.require(:id)
        begin
          @score = Score.find(id)
        rescue Mongoid::Errors::DocumentNotFound
          return render json: {
                            error: "failed to score for id: #{params[:id]}",
                            status: :not_found
                        }, status: :not_found
        end
      end

    private
      def parse_search_query(query)
        # TODO figure out how to do this with regexp
        result = {
            non_username_query_terms: '',
            username: nil
        }
        query_terms = query.split(' ')
        query_terms.each do |query_term|
          if query_term.include? 'username:'
            result[:username] = query_term.split(':')[1]
          else
            result[:non_username_query_terms] += ' ' + query_term
          end
        end
        return result
      end
    end
  end
end