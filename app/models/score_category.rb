class ScoreCategory
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :description, type: String
  field :general, type: Boolean, default: false

  validates_presence_of :name, :description
  validates_uniqueness_of :name

  def to_builder
    Jbuilder.new do |category|
      category.id self.id.to_s
      category.name self.name
      category.description self.description
    end
  end

  def self.generate_score_categories_map
    map = {}
    ScoreCategory.all.map do |score_category|
      map[score_category._id.to_s] = score_category
      if score_category.general?
        map[:general] = score_category
      end
    end
    map
  end
end