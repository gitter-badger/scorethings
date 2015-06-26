class StatsService
  def thing_stats_by_criterion(thing_id, criterion_id)
    thing = Thing.find(thing_id)
    total = thing.scores.where(criterion_id: criterion_id).length
    max = thing.scores.where(criterion_id: criterion_id).max(:points)
    min = thing.scores.where(criterion_id: criterion_id).min(:points)
    avg = thing.scores.where(criterion_id: criterion_id).avg(:points)

    return Stats.new(total: total, max: max, min: min, avg: avg)
  end

  def thing_stats(thing_id)
    thing = Thing.find(thing_id)
    total = thing.scores.length
    max = thing.scores.max(:points)
    min = thing.scores.min(:points)
    avg = thing.scores.avg(:points)

    return Stats.new(total: total, max: max, min: min, avg: avg)
  end
end