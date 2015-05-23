json.array! @scores do |score|
  json.user score.user.to_builder
  json.thing score.thing.to_builder
  json.points score.points
  json.score_category score.score_category.to_builder
  json.id score._id.to_s
  json.token score.token
  json.created_at score.created_at
  json.updated_at score.updated_at
end
