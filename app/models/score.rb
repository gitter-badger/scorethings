class Score
  include Mongoid::Document
  embeds_many :subscores
  belongs_to :user
  embeds_one :score_subject

  def calculate_total_score
    total_score = 0

    self.subscores.each do |subscore|
      total_score += subscore.get_score_calculation
    end
    return total_score
  end
  
  def add_or_change_subscore(criterion, new_subscore_value)
    self.subscores.each do |subscore|
      if subscore.criterion == criterion
        # if the score already has a value for this criterion, overwrite it
        puts "\n\n\nsetting new subscore value:  #{new_subscore_value}"
        subscore.value = new_subscore_value
        return
      end
    end
    subscore = Subscore.new
    subscore.criterion = criterion
    subscore.value = new_subscore_value
    subscore.score = self
  end
end