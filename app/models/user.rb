class User
  include Mongoid::Document
  # TODO change fields because only twitter will be used for auth provider
  field :twitter_uid, type: String # this is the uid from the provider (ex: twitter:298239)
  field :twitter_handle, type: String
  field :join_date, type: Time

  has_many :scores
  embeds_many :criterion_balances

  INITIAL_CRITERION_BALANCE = 1000

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

  def initialize_criterion_balance
    # this initializes the user's criterion_balance to include
    # an initial balance for all of the current Criterion

    # TODO I think some sort of reactive programming should handle
    # initializing the criterion balances for users when new criterion are added
    # but I'm not really familiar with reactive programming, so it might not be the
    # correct solution

    balance_change_time = Time.now

    Criterion.all.each do |criterion|
      if self.criterion_balances.where(criterion: criterion._id).first.nil?
        # if the user doesn't have the criterion balance, add it
        criterion_balance = CriterionBalance.new
        criterion_balance.date_last_modified = balance_change_time
        criterion_balance.total_balance = INITIAL_CRITERION_BALANCE
        criterion_balance.criterion = criterion._id
        self.criterion_balances << criterion_balance
      end
    end
  end

  def add_or_change_subscore(score, criterion, value)
    if score.user != self
      raise AccessDeniedError, "cannot add subscore to score, user does not own score"
    end
    if criterion.nil?
      raise ArgumentError, "cannot add subscore to score, criterion is nil"
    end

    self.initialize_criterion_balance

    new_criterion_used_balance = score.add_or_change_subscore(criterion, value)
    criterion_balance = self.criterion_balances.where(criterion: criterion._id).first
    criterion_balance.used_balance = new_criterion_used_balance
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

      user.initialize_criterion_balance
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

