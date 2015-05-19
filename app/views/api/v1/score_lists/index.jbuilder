json.array! @score_lists do |score_list|
  json.user score_list.user.to_builder
  json.name score_list.name
  json.id score_list.id.to_s
  json.num_of_scores score_list.scores.length
  json.created_at score_list.created_at
  json.updated_at score_list.updated_at
end