class User
  include Mongoid::Document
  # TODO change fields because only twitter will be used for auth provider
  field :twitter_uid, type: String # this is the uid from the provider (ex: twitter:298239)
  field :twitter_handle, type: String
  field :join_date, type: Time

  has_many :scores
  embeds_one :user_points_total

  INITIAL_POINTS_TOTAL = 1000

  def create_score(attrs)
    score = Score.create!(
        score_subject: ScoreSubject.new(
            type: attrs[:subject_type],
            value: attrs[:subject_value]
        ),
        user: self)
    self.scores << score
    score
  end

  def initialize_points_balance
    # this initializes the user's points_balance to an initial amount
    self.user_points_total = UserPointsTotal.new(last_modified: Time.now, amount: INITIAL_POINTS_TOTAL)
  end

  def self.increase_user_points_total(user, increase_amount)
    user.user_points_total.amount += increase_amount
  end

  def add_or_change_subscore(score, criterion, value)
    if score.user != self
      raise AccessDeniedError, "cannot add subscore to score, user does not own score"
    end
    if criterion.nil?
      raise ArgumentError, "cannot add subscore to score, criterion is nil"
    end

    score.add_or_change_subscore(criterion, value)
  end

  def remaining_points
    total_used = 0
    self.scores.each do |score|
      total_used += score.calculate_total_score
    end
    self.user_points_total.amount - total_used
  end

  def self.create_with_omniauth(auth)
    # copied from
    # http://railsapps.github.io/tutorial-rails-mongoid-omniauth.html

    create! do |user|
      user.twitter_uid = auth[:uid]

      auth_info = auth[:info]
      if auth_info.nil?
        # TODO throw error if you can't get the twitter nickname for the handle?
      end

      user.twitter_handle = auth_info[:nickname]

      user.initialize_points_balance
    end
  end

  def generate_auth_token
    payload = {
        user_id: self._id.to_s,
        twitter_handle: self.twitter_handle,
        twitter_uid: self.twitter_uid
    }
    AuthToken.encode(payload)
  end
end

