class StatsService
  def get_score_stats(filters)
    scores = Score.all
    unless filters[:user].nil?
      scores = scores.where(user: filters[:user])
    end

    unless filters[:criterion].nil?
      scores = scores.where(criterion: filters[:criterion])
    end

    unless filters[:scored_thing].nil?
      scores = scores.where(scored_thing: filters[:scored_thing])
    end

    Stats.new(
        total: scores.length,
        max: scores.max(:points),
        min: scores.min(:points),
        avg: scores.avg(:points))
  end
end