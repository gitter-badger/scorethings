class TweetThingsController < ApplicationController
  def search
    render json: [
              'buy it',
              'use it',
              'break it',
              'fix it',
              'trash it',
              'change it',
              'etc.'
           ]
  end
end