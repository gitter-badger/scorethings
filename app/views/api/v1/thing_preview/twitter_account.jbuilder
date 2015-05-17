json.array! @thing_previews do |thing_preview|
  json.display_value thing_preview.display_value
  json.real_name thing_preview.real_name
  json.external_id thing_preview.external_id
  json.type thing_preview.type
  json.uri thing_preview.uri
  json.image_uri thing_preview.image_uri
  json.description thing_preview.description
  json.verified thing_preview.verified
end