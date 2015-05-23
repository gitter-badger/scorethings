class ScoreCategory
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Token

  field :name, type: String
  field :description, type: String
  field :general, type: Boolean, default: false

  token :contains => :fixed_numeric, :length => 8

  validates_presence_of :name, :description
  validates_uniqueness_of :name

  def to_builder
    Jbuilder.new do |score_category|
      score_category.id self.id.to_s
      score_category.token self.token
      score_category.name self.name
      score_category.description self.description
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