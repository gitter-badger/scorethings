module Api
  module V1
    class ThingPreviewController < ApplicationController
      # TODO allow unauthenticated read?
      skip_before_action :authenticate_request, :current_user, only: [:twitter_account]

      def twitter_account
        thing_input = params.require(:input)
        thing_preview_service = ThingPreviewService.new
        @thing_previews = thing_preview_service.preview_twitter_account(thing_input)

        if @thing_previews.nil?
          # could not create thing_preview
          return render json: {
                            error: "could not create preview of thing with value #{thing_input}",
                            status: :bad_request
                        }, status: :bad_request
        end

      end
    end
  end
end