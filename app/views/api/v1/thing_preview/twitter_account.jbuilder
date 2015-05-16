json.array! @thing_previews do |thing_preview|
  json.display_value thing_preview.display_value
  json.external_id thing_preview.external_id
  json.type thing_preview.type
  json.uri thing_preview.uri
  json.image_uri thing_preview.image_uri
end