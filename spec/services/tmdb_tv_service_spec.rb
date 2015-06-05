require 'rails_helper'

RSpec.describe TmdbTVService do
  before do
    @tmdb_tv_service = TmdbTVService.new
    @tmdb_tv ={
        "id"=>62445,
        "name"=>"Big Time in Hollywood, Fl",
        "original_name"=>"Tobolowsky Time in Hollywood, Fl",
        "poster_path"=>"/uJIfvSSd0V6S4e1nqgs9FyADWxc.jpg"
    }
  end

  describe "searching for tvs" do
    it "should search for a tv" do
      expect_any_instance_of(Tmdb::Search).to receive(:fetch).and_return([@tmdb_tv])
      expect_any_instance_of(Tmdb::Configuration).to receive(:base_url)
                                                 .and_return('http://test-tvpics.tmdb.org/t/p/')

      search_results = @tmdb_tv_service.search_tv_things('Hollywood, Fl')

      expect(search_results).to_not be_nil
      expect(search_results.length).to eq(1)

      search_result = search_results[0]
      expect(search_result).to_not be_nil
      expect(search_result.external_id).to eq(62445)
      expect(search_result.title).to eq('Big Time in Hollywood, Fl')
      expect(search_result.image_uri).to eq('http://test-tvpics.tmdb.org/t/p/w92/uJIfvSSd0V6S4e1nqgs9FyADWxc.jpg')
      expect(search_result.uri).to eq('https://www.themoviedb.org/tv/62445')
    end
  end

  describe "getting a tv thing" do
    it "should get a tv thing" do
      expect(Tmdb::TV).to receive(:detail).with(62445)
                                                 .and_return(@tmdb_tv)
      expect_any_instance_of(Tmdb::Configuration).to receive(:base_url)
                                                        .and_return('http://test-tvpics.tmdb.org/t/p/')

      thing = @tmdb_tv_service.get_tmdb_tv_thing(62445)
      expect(thing).to_not be_nil
      expect(thing.external_id).to eq(62445)
      expect(thing.title).to eq('Big Time in Hollywood, Fl')
      expect(thing.image_uri).to eq('http://test-tvpics.tmdb.org/t/p/w92/uJIfvSSd0V6S4e1nqgs9FyADWxc.jpg')
      expect(thing.uri).to eq('https://www.themoviedb.org/tv/62445')
    end

    it "should get a tv thing with no poster" do
      @tmdb_tv["poster_path"] = nil
      expect(Tmdb::TV).to receive(:detail).with(62445)
                              .and_return(@tmdb_tv)

      thing = @tmdb_tv_service.get_tmdb_tv_thing(62445)
      expect(thing.image_uri).to be_nil
    end

    it "should raise an error if thing cannot be retrieved" do
      expect(Tmdb::TV).to receive(:detail).with(62445).and_return({"status_code"=>6, "status_message"=>"Say whaaaaa?"})

      expect {
        @tmdb_tv_service.get_tmdb_tv_thing(62445)
      }.to raise_error(Exceptions::ThingNotFoundError)
    end
  end
end
