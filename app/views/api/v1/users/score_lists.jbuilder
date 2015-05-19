json.array! @score_lists do |score_list|
  json.name score_list.name
  json.id score_list.id.to_s
  json.average_score score_list.average_score
  json.created_at score_list.created_at
  json.updated_at score_list.updated_at
end