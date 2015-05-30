module Api
  module V1
    class ThingsController < ApplicationController
      # TODO allow unauthenticated read?
      skip_before_action :authenticate_request, :current_user, only: [:show, :index]

      def create
        thing_params = params.require(:thing).permit(:type, :external_id, :title)
        if thing_params[:type] == Scorethings::ThingTypes::HASHTAG
          @thing = Thing.find_or_create_by(type: Scorethings::ThingTypes::HASHTAG, title: thing_params[:title])
        else
          thing_service = ThingService.new
          @thing = thing_service.load_external_thing(thing_params[:type], thing_params[:external_id])
        end

        if @thing.nil?
          return render json: {
                            error: "unable to find thing",
                            status: :bad_request
                        }, status: :bad_request

        else
          render template: '/api/v1/things/create.jbuilder', status: :created, formats: [:json]
        end

      end

      def index
        valid_thing_types = [Scorethings::ThingTypes::TWITTER_ACCOUNT,
                             Scorethings::ThingTypes::TWITTER_TWEET,
                             Scorethings::ThingTypes::YOUTUBE_VIDEO,
                             Scorethings::ThingTypes::HASHTAG]

        type = params.require(:type)
        if !valid_thing_types.include? type
          return render json: {
                          error: "unable to search for thing with thing type #{type}",
                          status: :bad_request
                      }, status: :bad_request
        end

        query = params[:query]
        if query.nil?
          external_id = params[:external_id]
          puts "params: #{type}, #{external_id}"
          @things = Thing.where(type: type, external_id: external_id).as_json
        else
          thing_service = ThingService.new
          @things = thing_service.search(type, query)
        end
      end

      def show
        thing_id = params.require(:id)
        begin
          @thing = Thing.find(thing_id)
        rescue Mongoid::Errors::DocumentNotFound
          return render json: {
                            error: "thing was not found with id: #{thing_id}",
                            status: :not_found
                        }, status: :not_found
        end
      end
    end
  end
end