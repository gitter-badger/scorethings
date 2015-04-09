class SearchController < ApplicationController
  def index
    search_term = params[:query]
    if search_term.nil?
      render json: {
                 error: 'No query'
             },
             status: 400
    else
      search = Tmdb::Search.new
      search.resource('movie')
      search.query(params[:query])
      results = search.fetch

      render json: results,
             status: 200
    end
  end
end