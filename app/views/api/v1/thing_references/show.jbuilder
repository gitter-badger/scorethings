json.thing_reference do
  json.id @thing_reference.id.to_s
  json.token @thing_reference.token
  json.type @thing_reference.type
  json.external_id @thing_reference.external_id
  json.thing @thing.to_builder
  json.scores(@thing_reference.scores) do |score|
    json.id score.id.to_s
    json.token score.token
    json.points score.points
    json.user score.user.to_builder
  end
end
