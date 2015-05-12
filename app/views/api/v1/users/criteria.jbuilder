json.array! @criteria do |criterion|
  json.name criterion.name
  json.id criterion._id.to_s
  json.definition criterion.definition
  json.sign criterion.sign
  json.created_at criterion.created_at
  json.updated_at criterion.updated_at
  json.num_of_levels criterion.criterion_levels.length
end