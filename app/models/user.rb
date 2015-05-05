class User
  include Mongoid::Document
  # TODO change fields because only twitter will be used for auth provider
  field :twitter_uid, type: String # this is the uid from the provider (ex: 298239)
  # TODO get rid of twitter handle in User model, can be changed in twitter
  # just use twitter user id (uid)
  # I know nothing about twitter's work.  How I got to write an app on anything is totally amazing.
  field :twitter_handle, type: String
  field :join_date, type: Time

  has_many :scores
  embeds_one :user_points_total
  has_many :score_lists
  has_many :criteria # uses ActiveSupport::Inflector to understand criteria is plural criterion

  INITIAL_POINTS_TOTAL = 1000

  def create_score(attrs)
    default_criterion = self.criteria.where(is_user_default: true).first
    if default_criterion.nil?
      default_criterion = Criterion.create!(is_user_default: true, name: 'Default Criterion')
      self.criteria << default_criterion
    end
    score = Score.create!(
        thing: Thing.new(
            type: attrs[:thing_type],
            value: attrs[:thing_value]
        ),
        user: self)
    self.scores << score
    self.add_or_change_subscore(score, default_criterion, 0)
    score
  end

  def initialize_points_balance
    # this initializes the user's points_balance to an initial amount
    self.user_points_total = UserPointsTotal.new(last_modified: Time.now, amount: INITIAL_POINTS_TOTAL)
  end

  def self.increase_user_points_total(user, increase_amount)
    user.user_points_total.amount += increase_amount
  end

  def add_or_change_subscore(score, criterion, new_value)
    if score.user != self
      raise AccessDeniedError, "cannot add or change subscore, user does not own score"
    end
    if criterion.nil?
      raise ArgumentError, "cannot add or change subscore, criterion is nil"
    end
    if new_value.nil?
      raise ArgumentError, "cannot add or change subscore to score, new value is nil"
    end

    existing_subscore = score.subscores.where(criterion: criterion).first
    if !existing_subscore.nil?
      potential_remaining_points = self.remaining_points(
        new_updated_value: new_value,
        existing_subscore_id: existing_subscore._id
      )
    else
      potential_remaining_points = self.remaining_points(new_updated_value: new_value)
    end

    if potential_remaining_points < 0
      raise InsufficientPointsError, "cannot change subscore value to #{new_value} because " +
                                       "the user's remaining points would become #{potential_remaining_points}, and it can't be less than zero"
    end
    score.add_or_change_subscore(criterion, new_value)
  end

  def remaining_points(input = {})
    total_used = 0
    new_updated_value = input[:new_updated_value]
    existing_subscore_id = input[:existing_subscore_id]
    self.scores.each do |score|
      total_used += score.calculate_total_score(input)
    end
    self.user_points_total.amount - (total_used + ((!new_updated_value.nil? && existing_subscore_id.nil?) ? new_updated_value.to_i : 0))
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

  def create_or_find_score_for_things(attrs)
    score = self.scores.where({'thing.type' => attrs[:thing_type], 'thing.value' => attrs[:thing_value]}).first
    if score.nil?
      score = self.create_score(thing_type: attrs[:thing_type], thing_value: attrs[:thing_value])
    end
    if score.nil?
      raise "could not create or find score for thing #{attrs}"
    end
    score
  end

  def create_criterion(attrs)
    criterion = Criterion.new(attrs)
    criterion.system_provided = false
    self.criteria << criterion
    criterion
  end
end

