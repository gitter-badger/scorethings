class StatsService
  def get_score_stats(filters)
    scores = Score.all
    unless filters[:user].nil?
      scores = scores.where(user: filters[:user])
    end

    unless filters[:criterion].nil?
      scores = scores.where(criterion: filters[:criterion])
    end

    unless filters[:thing].nil?
      scores = scores.where(thing: filters[:thing])
    end

    Stats.new(
        total: scores.length,
        max: scores.max(:points),
        min: scores.min(:points),
        avg: scores.avg(:points))
  end
end