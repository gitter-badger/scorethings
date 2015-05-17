class ThingPreview
  @display_value = nil
  @real_name = nil
  @type = nil
  @external_id = nil
  @image_uri = nil
  @uri = nil
  @description = nil
  @verified = nil

  attr_accessor :display_value, :real_name, :type, :external_id, :image_uri, :uri, :description, :verified

  def initialize(attrs)
    @display_value = attrs[:display_value]
    @real_name = attrs[:real_name]
    @type = attrs[:type]
    @external_id = attrs[:external_id]
    @image_uri = attrs[:image_uri]
    @uri = attrs[:uri]
    @description = attrs[:description]
    @verified = attrs[:verified]
  end
end

