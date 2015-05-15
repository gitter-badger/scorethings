module Api
  module V1
    class AutocompleteController < ApplicationController
      # TODO allow unauthenticated read?
      skip_before_action :authenticate_request, :current_user, only: [:search]

      def search
        thing_type = params.require(:thing_type)
        query = params.require(:query)
        if thing_type == Scorething::ThingTypes::TWITTER_ACCOUNT
          twitter_service = TwitterService.new
          results = twitter_service.search_for_twitter_accounts(query)
          render json: {
                     results: results,
                     status: :ok
                 }, status: :ok
        end

        render json: {
                   error: "Unsupported thing type to autocomplete: #{thing_type}",
                   status: :bad_request
               }, status: :bad_request
      end
    end
  end
end