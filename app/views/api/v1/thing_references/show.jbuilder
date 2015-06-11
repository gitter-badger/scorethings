json.thing_reference do
  json.id @thing_reference.id.to_s
  json.token @thing_reference.token
  json.type @thing_reference.type
  json.dbpedia_uri @thing_reference.dbpedia_uri
  json.thing @thing.to_builder
  json.scores(@thing_reference.scores) do |score|
    json.id score.id.to_s
    json.token score.token
    json.points score.points
    json.user score.user.to_builder
  end
end
