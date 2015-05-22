module Api
  module V1
    class ThingsController < ApplicationController
      # TODO allow unauthenticated read?
      skip_before_action :authenticate_request, :current_user, only: [:search, :show, :score]

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

      def search
        valid_thing_types = [Scorethings::ThingTypes::TWITTER_ACCOUNT,
                             Scorethings::ThingTypes::TWITTER_TWEET,
                             Scorethings::ThingTypes::YOUTUBE_VIDEO,
                             Scorethings::ThingTypes::HASHTAG]

        thing_type = params.require(:thing_type)
        if !valid_thing_types.include? thing_type
          return render json: {
                          error: "unable to search for thing with thing type #{thing_type}",
                          status: :bad_request
                      }, status: :bad_request
        end
        query = params.require(:query)

        thing_service = ThingService.new
        @things = thing_service.search(thing_type, query)

        if @things.nil?
          # could not create thing_preview
          return render json: {
                            error: "could not find things with value #{query}",
                            status: :bad_request
                        }, status: :bad_request
        end
      end

      def find
        valid_thing_types = [Scorethings::ThingTypes::TWITTER_ACCOUNT,
                             Scorethings::ThingTypes::TWITTER_TWEET,
                             Scorethings::ThingTypes::YOUTUBE_VIDEO,
                             Scorethings::ThingTypes::HASHTAG]

        thing_type = params.require(:thing_type)
        if !valid_thing_types.include? thing_type
          return render json: {
                            error: "unable to search for thing with thing type #{thing_type}",
                            status: :bad_request
                        }, status: :bad_request
        end
        external_id = params[:external_id]
        if external_id.nil? && thing_type != Scorethings::ThingTypes::HASHTAG
          return render json: {
                            error: "cannot find thing without external id, unless type is hashtag",
                            status: :bad_request
                        }, status: :bad_request
        end

        @thing = Thing.where(type: thing_type, external_id: external_id).first
        if @thing.nil?
          return render json: {
                            error: "thing was not found with type: #{thing_type} and external id #{external_id}",
                            status: :not_found
                        }, status: :not_found

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

     def scores
       thing_id = params.require(:thing_id)
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