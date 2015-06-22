module Exceptions
  class ScoreNotUniqueError < StandardError
    attr :existing_score

    def initialize(existing_score)
      @existing_score = existing_score
    end
  end
end
