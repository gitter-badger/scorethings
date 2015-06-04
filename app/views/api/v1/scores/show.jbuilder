json.score do
  json.id @score._id.to_s
  json.token @score.token
  json.user @score.user.to_builder
  json.thing_reference @score.thing_reference.to_builder
  json.thing_id @score.thing_reference.id.to_s
  json.thing @thing.to_builder unless @thing.nil?
  json.points @score.points
  json.good_point @score.good_point

  json.created_at @score.created_at
  json.updated_at @score.updated_at
end