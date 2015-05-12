json.score do
  json.user @score.user.to_builder
  json.thing @score.thing.to_builder
  json.total_score @score.calculate_total_score
  json.created_at @score.created_at
  json.updated_at @score.updated_at
  json.subscores @score.subscores do |subscore|
    json.criterion subscore.criterion.to_builder
    json.value subscore.value
    json.created_at subscore.created_at
    json.updated_at subscore.updated_at
  end
end