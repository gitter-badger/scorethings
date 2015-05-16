json.array! @suggestions do |suggestion|
  json.id suggestion.id
  json.display_name suggestion.display_name
  json.secondary_name suggestion.secondary_name
  json.url suggestion.url
  json.description suggestion.description
end
