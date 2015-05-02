class Score
  include Mongoid::Document
  embeds_many :score_criterion_values
  belongs_to :user
  embeds_one :score_subject

  def calculate_total_score
    total_score = 0

    self.score_criterion_values.each do |scv|
      total_score += scv.value
    end
    return total_score
  end
end