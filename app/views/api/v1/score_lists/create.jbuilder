json.score_list do
  json.id @score_list.id.to_s
  json.token @score_list.token
  json.user @score_list.user.to_builder
  json.name @score_list.name
end
