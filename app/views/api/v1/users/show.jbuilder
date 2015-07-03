json.user do
  json.id @user._id.to_s
  json.token @user.token
  json.username @user.username
  json.created_at @user.created_at
  json.updated_at @user.updated_at
  json.scores @user.scores.each do |score|
    json.id score._id.to_s
    json.token score.token
    json.scored_thing score.scored_thing.to_builder
    json.points score.points
    json.criterion score.criterion
  end
end
