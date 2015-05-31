json.web_thing do
  json.external_id @web_thing.external_id
  json.title @web_thing.title
  json.secondary_title @web_thing.secondary_title
  json.type @web_thing.type
  json.image_uri @web_thing.image_uri
  json.uri @web_thing.uri
  json.content @web_thing.content
  json.verified @web_thing.verified
  json.thing @web_thing.thing.to_builder
  json.thing @thing.to_builder unless @thing.nil?
end