json.score do
  json.user @score.user.to_builder
  json.thing @score.thing.to_builder
  json.total_score @score.calculate_total_score
  json.subscores @score.subscores do |subscore|
    json.criterion subscore.criterion.to_builder
    json.value subscore.value
  end
end