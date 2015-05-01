class User
  include Mongoid::Document
  # TODO change fields because only twitter will be used for auth provider
  field :twitterUid, type: String # this is the uid from the provider (ex: twitter:298239)
  field :twitterHandle, type: String
  field :email, type: String

  has_many :scores

  def self.create_with_omniauth(auth)
    # copied from
    # http://railsapps.github.io/tutorial-rails-mongoid-omniauth.html
    create! do |user|
      user.twitterUid = auth['uid']
      if auth['info']
        # TODO throw error if you can't get the @handle or email?
        user.twitterHandle = auth['info']['nickname'] || ""
        user.email = auth['info']['email'] || ""
      end
    end
  end

  def generate_auth_token
    payload = {
        user_id: self._id.to_s,
        twitterHandle: self.twitterHandle,
        twitterUid: self.twitterUid
    }
    AuthToken.encode(payload)
  end
end

