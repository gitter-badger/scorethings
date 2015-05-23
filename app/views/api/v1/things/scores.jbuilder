json.thing do
  json.id @thing.id.to_s
  json.token @thing.token
  json.title @thing.title
  json.type @thing.type
  json.external_id @thing.external_id
  json.image_uri @thing.image_uri
  json.uri @thing.uri
  json.description @thing.description
  json.verified @thing.verified
  json.scores(@thing.scores) do |score|
    json.id score.id.to_s
    json.token score.token
    json.points score.points
    json.user score.user.to_builder
  end
end