json.score do
  json.user @score.user.to_builder
  json.thing @score.thing.to_builder
  json.points @score.points
  json.id @score._id.to_s
  json.created_at @score.created_at
  json.updated_at @score.updated_at

  json.category @score.category.to_builder
end
