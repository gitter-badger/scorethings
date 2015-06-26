class Stats
  attr_accessor :min, :max, :total, :avg

  def initialize(attrs)
    @min = attrs[:min]
    @max = attrs[:max]
    @total = attrs[:total]
    @avg = attrs[:avg]
  end
end