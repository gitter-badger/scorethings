json.web_thing do
  json.external_id @web_thing.external_id
  json.title @web_thing.title
  json.type @web_thing.type
  json.image_uri @web_thing.image_uri
  json.uri @web_thing.uri
  json.verified @web_thing.verified
  json.thing_reference @thing_reference.to_builder unless @thing_reference.nil?
end