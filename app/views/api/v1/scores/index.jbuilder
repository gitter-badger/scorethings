json.array! @scores do |score|
  json.user score.user.to_builder
  json.thing score.thing.to_builder
  json.total_score score.calculate_total_score
  json.id score._id.to_s
end