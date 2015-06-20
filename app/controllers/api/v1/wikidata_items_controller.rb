module Api
  module V1
    class WikidataItemsController < ApplicationController
      skip_before_action :authenticate_request

      def find
        wikidata_item_id = params.require(:wikidata_item_id)
        begin
          @wikidata_item = $thing_service.find(wikidata_item_id)
        rescue Exceptions::WikidataItemNotFoundError
          return render json: {
                            message: "could not find wikipedia page info",
                            status: :not_found
                        }, status: :not_found
        end
        return render json: {
                          wikidata_item: @wikidata_item,
                          status: :ok
                      }, status: :ok
      end

      def search
        query = params.require(:query)
        @search_results = $thing_service.search(query)
        return render json: {
                          search_results: @search_results,
                          status: :ok
                      }, status: :ok
      end
    end
  end
end