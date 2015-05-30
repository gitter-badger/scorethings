require 'rails_helper'

RSpec.describe Api::V1::ThingsController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)

  describe "POST create" do
    before do
      @user = create(:user_alpha)
      auth_token = @user.generate_auth_token.to_s
      @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
    end

    xit "should create a twitter account thing" do
      # post thing with just external id and type
      params = {
         thing: {
             external_id: '111',
             type: Scorethings::ThingTypes::TWITTER_ACCOUNT
         }
      }
      thing = build(:thing, :twitter_account, external_id: '111')

      allow_any_instance_of(ThingService).to receive(:load_external_thing).with(Scorethings::ThingTypes::TWITTER_ACCOUNT, '111')
                                                 .and_return(thing)
      post :create, params
      expect(response).to have_http_status(:created)
      expect(assigns(:thing)).to_not be_nil
    end
  end

  describe "GET index" do
    before do
      @user = create(:user_alpha)
      auth_token = @user.generate_auth_token.to_s
      @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
    end

    describe "searching for existing things with external_id and type" do
      before do
        @existing_things = create_list(:thing, 3, :twitter_account)
      end

     xit "should respond with array of things" do
        get :index, {type: @existing_things[0].type, external_id: @existing_things[0].external_id}
        expect(response).to have_http_status(:ok)
        expect(assigns(:things)).to eq([@existing_things[0].to_json])
      end
    end

    describe "searching for things with a query and type" do
      before do
        @things = build_list(:thing, 2, :twitter_account)
      end

      xit "should respond with array of things" do
        allow_any_instance_of(ThingService).to receive(:search).with('twitter_account', 'SomeTwitterUser').and_return(@things)
        get :index, {type: 'twitter_account', query: 'SomeTwitterUser'}
        expect(response).to have_http_status(:ok)
        expect(assigns(:things)).to eq([@things])
      end

      xit "should respond with empty array" do
        allow_any_instance_of(ThingService).to receive(:search).with('twitter_account', 'SomeTwitterUser').and_return([])
        get :index, {type: 'twitter_account', query: 'SomeTwitterUser'}
        expect(response).to have_http_status(:ok)
        expect(assigns(:things)).to eq([])
      end

      xit "should say bad request if unknown thing type param" do
        get :index, {type: 'some_nonexistent_website', query: 'SomeUser'}
        expect(response).to have_http_status(:bad_request)
      end

    end

  end
end
