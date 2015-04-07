class SearchController < ApplicationController
  def index
    search_term = params[:search_term]
    if search_term.nil?
      render json: {
                 error: 'No search_term'
             },
             status: 400
    else
      render json: [
                 {
                     name: 'The Blues Brothers',
                     date: 1980
                 },
                 {
                     name: 'The Avengers',
                     date: 2012
                 },
                 {
                     name: 'Furious 7',
                     date: 2015
                 }
             ],
             status: 200
    end
  end
end
