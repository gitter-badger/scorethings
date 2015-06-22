json.score do
  json.id @score._id.to_s
  json.token @score.token
  json.user @score.user.to_builder
  json.thing @score.thing.to_builder
  json.points @score.points
  json.criterion @score.criterion

  json.created_at @score.created_at
  json.updated_at @score.updated_at
end