json.score do
  json.user @score.user.to_builder
  json.thing @score.thing.to_builder
  json.points @score.points
  json.id @score._id.to_s
  json.created_at @score.created_at
  json.updated_at @score.updated_at
  json.score_lists(@score.score_lists) do |score_list|
    json.id score_list.id.to_s
    json.name score_list.name
  end

  json.category @score.score_category.to_builder
end
