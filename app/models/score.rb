class Score
  include Mongoid::Document
  embeds_many :score_criterion_values
  belongs_to :user
  embeds_one :score_subject

  def calculate_total_score
    total_score = 0

    self.score_criterion_values.each do |scv|
      total_score += scv.get_score_calculation
    end
    return total_score
  end
  
  def add_score_criterion_value(criterion, value)
    self.score_criterion_values.each do |scv|
      if scv.criterion == criterion
        raise "cannot have two score criterion values with same criterion"
      end
    end
    score_criterion_value = ScoreCriterionValue.new
    score_criterion_value.criterion = criterion
    score_criterion_value.value = value
    score_criterion_value.score = self
  end
end