json.user do
  json.id @current_user._id.to_s
  json.token @current_user.token
  json.username @current_user.username
  json.description @current_user.description
  json.created_at @current_user.created_at
  json.updated_at @current_user.updated_at
end
