class ThingCategory
  include Mongoid::Document

  field :resource_name, type: String # example: Category:20th-century_American_male_actors
  field :label, type: String # example: 20th-century American male actors
  embedded_in :thing
end