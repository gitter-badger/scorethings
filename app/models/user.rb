class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # FIXME move twitter uid and handle(?) into new AuthProvider embeded doc
  # want to have multiple providers (Google, Facebook, SoundCloud, etc.)
  # allow user to link different accounts to one scorethings account
  field :twitter_uid, type: String
  field :twitter_handle, type: String

  has_many :scores

  def to_builder
    Jbuilder.new do |user|
      user.twitter_uid self.twitter_uid
      user.id self._id.to_s
    end
  end

  def score_thing(thing, category)
    score = Score.create!(thing: thing, user: self, category: category)
    self.scores << score
    score
  end

  # TODO common logic between delete and change score
  def delete_score(score)
    if self != score.user
      raise UnauthorizedModificationError
    end
    score.destroy
  end

  def change_score(score, update_attrs)
    if self != score.user
      raise UnauthorizedModificationError
    end
    score.update_attributes(update_attrs)
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
end

