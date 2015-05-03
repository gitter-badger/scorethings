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
  
  def add_or_change_subscore(criterion, new_subscore_criterion_value)
    self.subscores.each do |subscore|
      if subscore.criterion == criterion
        # if the score already has a value for this criterion, overwrite it

        # return the new value as the new used balance (used to keep track of remaining)
        return subscore.value = new_subscore_criterion_value
      end
    end
    subscore = Subscore.new
    subscore.criterion = criterion
    subscore.value = new_subscore_criterion_value
    subscore.score = self
    return new_subscore_criterion_value
  end
end