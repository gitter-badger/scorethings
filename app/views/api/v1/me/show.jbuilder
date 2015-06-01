json.user do
  json.username @user.username
  json.id @user._id.to_s
  json.token @user.token
  json.description @user.description
  json.created_at @user.created_at
  json.updated_at @user.updated_at

  json.default_points @user.default_points

  json.scores(@user.scores) do |score|
    json.id score.id.to_s
    json.token score.token
    json.thing score.thing.to_builder
    json.score_category score.score_category.to_builder
  end
end
