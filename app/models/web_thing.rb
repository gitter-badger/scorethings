class WebThing
  # the WebThing is not persisted in a database, it just represents a potential thing
  # that exists on the internet.  It can be used to create a Thing.
  @title = nil
  @secondary_title = nil
  @external_id = nil
  @uri = nil
  @image_uri = nil
  @verified = nil
  @content = nil
  @type = nil
  @thing = nil

  attr_accessor :title, :secondary_title, :external_id, :uri, :image_uri, :verified, :content, :type, :thing

  def initialize(attrs)
    @title = attrs[:title]
    @secondary_title = attrs[:secondary_title]
    @external_id = attrs[:external_id]
    @uri = attrs[:uri]
    @image_uri = attrs[:image_uri]
    @verified = attrs[:verified] || false
    @content = attrs[:content]
    @type = attrs[:type]
    @thing = attrs[:thing]
  end

  def to_builder
    Jbuilder.new do |web_thing|
      web_thing.title @title
      web_thing.secondary_title @secondary_title
      web_thing.external_id @external_id
      web_thing.uri @uri
      web_thing.image_uri @image_uri
      web_thing.verified @verified
      web_thing.content @content
      web_thing.type @type
    end
  end

  def self.build_from_hashtag(hashtag)
    if hashtag.nil?
      raise "cannot build hashtag with nil value"
    end

    if hashtag[0] == '#'
      hashtag[0] = ''
    end

    WebThing.new(title: "##{hashtag}",
                 external_id: hashtag,
                 type: Scorethings::ThingTypes::HASHTAG)
  end
end