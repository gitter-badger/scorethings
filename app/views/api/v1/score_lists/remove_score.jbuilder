json.score_list do
  json.id @score_list.id.to_s
  json.token @score_list.token
  json.user @score_list.user.to_builder
  json.name @score_list.name

  json.created_at @score_list.created_at
  json.updated_at @score_list.updated_at

  json.average_score @score_list.average_score
  json.scores(@score_list.scores) do |score|
    json.thing score.thing.to_builder
    json.points score.points
    json.id score._id.to_s
    json.score_category score.score_category.to_builder
  end
end
