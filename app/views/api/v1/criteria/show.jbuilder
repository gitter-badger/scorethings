json.array! @criteria do |criterion|
  json.name criterion.name
  json.id criterion._id.to_s
  json.definition criterion.definition
  json.sign criterion.sign
  json.created_at criterion.created_at
  json.updated_at criterion.updated_at
  json.user criterion.user.to_builder
  json.criterion_levels criterion.criterion_levels do |criterion_level|
    json.name criterion_level.name
    json.level_number criterion_level.level_number
    json.ceiling criterion_level.ceiling
    json.floor criterion_level.floor
    json.id criterion_level._id.to_s
    json.created_at criterion_level.created_at
    json.updated_at criterion_level.updated_at
  end
end
