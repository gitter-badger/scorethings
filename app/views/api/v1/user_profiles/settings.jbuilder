json.settings do
  json.default_points @current_user.user_settings.default_points
  json.default_meh_minimum @current_user.user_settings.default_meh_minimum
  json.default_meh_maximum @current_user.user_settings.default_meh_maximum
end