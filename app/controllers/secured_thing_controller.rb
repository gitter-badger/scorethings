class SecuredThingController < ApplicationController
  def show
    render json: {
               message: 'This is a secured message from the server'
           }
  end
end