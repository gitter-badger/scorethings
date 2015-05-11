class Score
  include Mongoid::Document
  embeds_many :subscores
  belongs_to :user
  embeds_one :thing
  has_and_belongs_to_many :score_lists

  def to_builder
    Jbuilder.new do |score|
      score.user self.user.to_builder
      score.thing self.thing.to_builder
      score.subscores score.subscores do |subscore|
        subscore.to_builder
      end
    end
  end

  def low_detail_to_builder
    Jbuilder.new do |score|
      score.thing self.thing.to_builder
      score.total_score self.calculate_total_score
      score.cool "this is cool"
    end
  end

  def calculate_total_score(input = {})
    total_score = 0
    new_updated_value = input[:new_updated_value]
    existing_subscore_id = input[:existing_subscore_id]

    self.subscores.each do |subscore|
      if !existing_subscore_id.nil? && (subscore._id == existing_subscore_id)
        total_score += subscore.get_score_calculation(new_updated_value)
      else
        total_score += subscore.get_score_calculation
      end
    end
    return total_score
  end
  
  def add_or_change_subscore(criterion, new_subscore_value)
    self.subscores.each do |subscore|
      if subscore.criterion == criterion
        # if the score already has a value for this criterion, overwrite it
        subscore.value = new_subscore_value
        return
      end
    end
   self.subscores.create!(criterion: criterion, value: new_subscore_value)
  end
end