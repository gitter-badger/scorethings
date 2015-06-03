json.score do
  json.id @score._id.to_s
  json.token @score.token
  json.user @score.user.to_builder
  json.thing @score.thing.to_builder
  json.thing_id @score.thing.id.to_s
  json.web_thing @web_thing.to_builder unless @web_thing.nil?
  json.points @score.points
  json.meh_floor @score.meh_floor
  json.meh_ceiling @score.meh_ceiling
  json.score_archives(@score.score_archives) do |score_archive|
    json.id score_archive.id
    json.token score_archive.token
    json.created_at score_archive.created_at
    json.points score_archive.points
    json.meh_floor score_archive.meh_floor
    json.meh_ceiling score_archive.meh_ceiling
  end

  json.created_at @score.created_at
  json.updated_at @score.updated_at
end

