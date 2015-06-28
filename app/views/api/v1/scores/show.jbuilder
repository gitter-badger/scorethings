json.score do
  json.id @score._id.to_s
  json.token @score.token
  json.user @score.user.to_builder
  json.scored_thing @score.scored_thing.to_builder
  json.points @score.points
  json.criterion @score.criterion

  json.created_at @score.created_at
  json.updated_at @score.updated_at
  json.old_points @score.old_points.each do |old_points|
    json.points old_points.points
    json.started_at old_points.started_at
    json.ended_at old_points.ended_at
  end
end