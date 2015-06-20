module Api
  module V1
    class WikipediaPagesController < ApplicationController
      skip_before_action :authenticate_request

      def search
        query = params.require(:query)
        begin
          @wikipedia_page_info = $thing_service.find(query)
        rescue Exceptions::WikipediaPageInfoNotFoundError
          return render json: {
                            message: "could not find wikipedia page info",
                            status: :not_found
                        }, status: :not_found
        end
        return render json: {
                          wikipedia_page_info: @wikipedia_page_info,
                          status: :ok
                      }, status: :ok
      end
    end
  end
end