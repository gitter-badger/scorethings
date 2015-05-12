json.score do
  json.user @score.user.to_builder
  json.thing @score.thing.to_builder
  json.points @score.points
  json.id @score._id.to_s
  json.created_at @score.created_at
  json.updated_at @score.updated_at
  json.score_categories @score.score_categories do |score_category|
    json.category score_category.category.to_builder
    json.points score_category.points
    json.created_at score_category.created_at
    json.updated_at score_category.updated_at
  end
end
