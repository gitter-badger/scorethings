class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # TODO change fields because only twitter will be used for auth provider
  field :twitter_uid, type: String # this is the uid from the provider (ex: 298239)
  # TODO update twitter handle, as it may be changed in twitter
  field :twitter_handle, type: String

  has_many :scores
  has_many :score_lists
  has_many :criteria # uses ActiveSupport::Inflector to understand criteria is plural criterion

  validates_presence_of :twitter_uid

  def to_builder
    Jbuilder.new do |user|
      user.twitter_handle self.twitter_handle
      user.twitter_uid self.twitter_uid
      user.id self._id.to_s
    end
  end

  def create_score(attrs)
    # find or create a general criterion so that when the score is created, it's not just empty with no subscores
    # (want it to be less confusing for user)
    general_criterion = Criterion.where(user: self, is_general: true).first
    if general_criterion.nil?
      general_criterion = Criterion.create_general_criterion(self)
    end
    score = Score.create!(
        thing: Thing.new(
            type: attrs[:thing_type],
            value: attrs[:thing_value]
        ),
        user: self)
    self.scores << score

    # put general criterion in subscores of new score
    self.add_or_change_subscore(score, general_criterion, 0)
    score
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
    score.add_or_change_subscore(criterion, new_value)
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

