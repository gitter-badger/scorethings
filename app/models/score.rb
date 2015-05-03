class Score
  include Mongoid::Document
  embeds_many :subscores
  belongs_to :user
  embeds_one :score_subject

  def calculate_total_score
    total_score = 0

    self.subscores.each do |scv|
      total_score += scv.get_score_calculation
    end
    return total_score
  end
  
  def add_subscore(criterion, value)
    self.subscores.each do |scv|
      if scv.criterion == criterion
        # if the score already has a value for this criterion, overwrite it
        scv.value = value
        return
      end
    end
    subscore = Subscore.new
    subscore.criterion = criterion
    subscore.value = value
    subscore.score = self
  end
end