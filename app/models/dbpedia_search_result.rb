class DbpediaSearchResult
  @resource_name = nil
  @label = nil
  @description = nil

  attr_accessor :resource_name, :label, :description

  def initialize(attrs)
    @resource_name = attrs[:resource_name]
    @label = attrs[:label]
    @description = attrs[:description]
  end
end