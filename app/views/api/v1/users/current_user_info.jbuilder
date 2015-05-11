json.current_user_info do
  json.id @user.id
  json.twitter_uid @user.twitter_uid
  json.join_date @user.join_date


  json.scores @user.scores do |score|
    json.total_score score.calculate_total_score
    json.thing score.thing
    json.id score.id.to_s
  end
  json.criteria @user.criteria do |criterion|
    json.name criterion.name
    json.sign criterion.sign
    json.definition criterion.definition
    json.id criterion.id.to_s
  end
end