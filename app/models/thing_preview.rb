class ThingPreview
  @display_value = nil
  @type = nil
  @external_id = nil
  @image_uri = nil
  @uri = nil

  attr_accessor :display_value, :type, :external_id, :image_uri, :uri

  def initialize(attrs)
    @display_value = attrs[:display_value]
    @type = attrs[:type]
    @external_id = attrs[:external_id]
    @image_uri = attrs[:image_uri]
    @uri = attrs[:uri]
  end
end

