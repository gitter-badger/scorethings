json.array! @scores do |score|
  json.thing score.thing.to_builder
  json.points score.points
  json.category score.category.to_builder
  json.id score._id.to_s
  json.created_at score.created_at
  json.updated_at score.updated_at
end