require 'rails_helper'

RSpec.describe TmdbMovieService do
  before do
    @tmdb_movie_service = TmdbMovieService.new
    @tmdb_movie ={
        "adult"=>false,
        "backdrop_path"=>"/n9xfxK6iAyzSSZkoso0wtCBVm8s.jpg",
        "genre_ids"=>[18],
        "id"=>4960,
        "original_title"=>"Living in Sin...ecdoche, New York",
        "overview"=>"A theater director struggles with his work, and the women in blah blah blah..",
        "release_date"=>"2008-10-24",
        "poster_path"=>"/5nO6wAFWBG36APWqgzKmF70HJQV.jpg",
        "popularity"=>1.355011,
        "title"=>"Synecdoche, New York"
    }
  end

  describe "searching for movies" do
    it "should search for a movie" do
      expect_any_instance_of(Tmdb::Search).to receive(:fetch).and_return([@tmdb_movie])
      expect_any_instance_of(Tmdb::Configuration).to receive(:base_url)
                                                 .and_return('http://test-moviepics.tmdb.org/t/p/')

      search_results = @tmdb_movie_service.search_movie_things('Synecdoche')

      expect(search_results).to_not be_nil
      expect(search_results.length).to eq(1)

      search_result = search_results[0]
      expect(search_result).to_not be_nil
      expect(search_result.external_id).to eq(4960)
      expect(search_result.title).to eq('Synecdoche, New York')
      expect(search_result.image_uri).to eq('http://test-moviepics.tmdb.org/t/p/w92/5nO6wAFWBG36APWqgzKmF70HJQV.jpg')
      expect(search_result.uri).to eq('https://www.themoviedb.org/movie/4960')
    end
  end

  describe "getting a movie thing" do
    it "should get a movie thing" do
      expect(Tmdb::Movie).to receive(:detail).with(4960)
                                                 .and_return(@tmdb_movie)
      expect_any_instance_of(Tmdb::Configuration).to receive(:base_url)
                                                        .and_return('http://test-moviepics.tmdb.org/t/p/')

      thing = @tmdb_movie_service.get_tmdb_movie_thing(4960)
      expect(thing).to_not be_nil
      expect(thing.external_id).to eq(4960)
      expect(thing.title).to eq('Synecdoche, New York')
      expect(thing.image_uri).to eq('http://test-moviepics.tmdb.org/t/p/w92/5nO6wAFWBG36APWqgzKmF70HJQV.jpg')
      expect(thing.uri).to eq('https://www.themoviedb.org/movie/4960')
    end

    it "should get a movie thing with no poster" do
      @tmdb_movie["poster_path"] = nil
      expect(Tmdb::Movie).to receive(:detail).with(62445)
                              .and_return(@tmdb_movie)

      thing = @tmdb_movie_service.get_tmdb_movie_thing(62445)
      expect(thing.image_uri).to be_nil
    end

    it "should raise an error if thing cannot be retrieved" do
      expect(Tmdb::Movie).to receive(:detail).with(4960).and_return({"status_code"=>6,
                                                                                    "status_message"=>"Say whaaaaa?"})

      expect {
        @tmdb_movie_service.get_tmdb_movie_thing(4960)
      }.to raise_error(Exceptions::ThingNotFoundError)
    end
  end
end
