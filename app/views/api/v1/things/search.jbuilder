json.array! @things do |thing|
  json.title thing.title
  json.type thing.type
  json.external_id thing.external_id
  json.image_uri thing.image_uri
  json.uri thing.uri
  json.description thing.description
  json.verified thing.verified
end