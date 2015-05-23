json.score do
  json.user @score.user.to_builder
  json.thing @score.thing.to_builder
  json.thing_id @score.thing.id.to_s
  json.points @score.points
  json.id @score._id.to_s
  json.token @score.token
  json.created_at @score.created_at
  json.updated_at @score.updated_at

  json.score_category @score.score_category.to_builder
  json.score_category_id @score.score_category.id.to_s
  json.score_lists(@score.score_lists) do |score_list|
    json.id score_list.id.to_s
    json.token score_list.token
    json.name score_list.name
  end
end
