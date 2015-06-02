json.score do
  json.user @score.user.to_builder
  json.thing @score.thing.to_builder
  json.thing_id @score.thing.id.to_s
  json.web_thing @web_thing.to_builder unless @web_thing.nil?
  json.points @score.points
  json.id @score._id.to_s
  json.token @score.token
  json.created_at @score.created_at
  json.updated_at @score.updated_at
end
