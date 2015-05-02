class User
  include Mongoid::Document
  # TODO change fields because only twitter will be used for auth provider
  field :twitter_uid, type: String # this is the uid from the provider (ex: twitter:298239)
  field :twitter_handle, type: String

  has_many :scores

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

  def add_score_criterion_value(score, criterion, value)
    if score.user != self
      throw "cannot add score criterion value to score, user does not own score"
    end
    if criterion.nil?
      throw "cannot add score criterion value to score, criterion is nil"
    end

    score.add_score_criterion_value(criterion, value)
  end

  def self.create_with_omniauth(auth)
    # copied from
    # http://railsapps.github.io/tutorial-rails-mongoid-omniauth.html
    create! do |user|
      user.twitter_uid = auth['uid']
      if auth['info']
        # TODO throw error if you can't get the twitter nickname for the handle?
        user.twitter_handle = auth['info']['nickname'] || ""
      end
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

