json.thing do
  json.external_id @thing.external_id
  json.title @thing.title
  json.type @thing.type
  json.image_uri @thing.image_uri
  json.uri @thing.uri
  json.verified @thing.verified
  json.thing_reference @thing_reference.to_builder unless @thing_reference.nil?
end