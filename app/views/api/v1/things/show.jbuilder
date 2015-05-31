json.thing do
  json.id @thing.id.to_s
  json.token @thing.token
  json.type @thing.type
  json.external_id @thing.external_id
  json.web_thing @web_thing.to_builder
  json.scores(@thing.scores) do |score|
    json.id score.id.to_s
    json.token score.token
    json.points score.points
    json.user score.user.to_builder
  end
end
