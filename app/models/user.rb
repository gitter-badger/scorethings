class User
  include Mongoid::Document
  # TODO change fields because only twitter will be used for auth provider
  field :twitter_uid, type: String # this is the uid from the provider (ex: twitter:298239)
  field :twitter_handle, type: String
  field :join_date, type: Time

  has_many :scores
  embeds_many :user_criterion_score_balances

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

  def initialize_score_points_balance(starting_balance)
    balance_change_time = Time.now

    Criterion.all.each do |criterion|
      ucsb = UserCriterionScoreBalance.new
      ucsb.date_last_modified = balance_change_time
      ucsb.remaining_balance = starting_balance
      ucsb.user = self
      ucsb.criterion = criterion._id
    end
  end

  def add_score_criterion_value(score, criterion, value)
    if score.user != self
      raise AccessDeniedError, "cannot add score criterion value to score, user does not own score"
    end
    if criterion.nil?
      raise ArgumentError, "cannot add score criterion value to score, criterion is nil"
    end

    score.add_score_criterion_value(criterion, value)
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

      user.initialize_score_points_balance(1000)
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

