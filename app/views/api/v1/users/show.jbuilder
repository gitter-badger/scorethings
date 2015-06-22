json.user do
  json.id @user._id.to_s
  json.token @user.token
  json.username @user.username
  json.created_at @user.created_at
  json.updated_at @user.updated_at
end
