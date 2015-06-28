json.array! @scores do |score|
  json.token score.token
  json.id score.id
  json.criterion score.criterion
  json.points score.points
  json.user score.user.to_builder
  json.scored_thing score.scored_thing.to_builder
end