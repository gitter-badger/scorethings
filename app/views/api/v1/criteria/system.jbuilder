json.array! @system_criteria do |criterion|
  json.name criterion.name
  json.id criterion._id.to_s
  json.definition criterion.definition
  json.sign criterion.sign
  json.criterion_levels criterion.criterion_levels do |criterion_level|
    json.name criterion_level.name
    json.level_number criterion_level.level_number
    json.ceiling criterion_level.ceiling
    json.floor criterion_level.floor
    json.id criterion_level._id.to_s
  end
end