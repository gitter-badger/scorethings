class User
  include Mongoid::Document
  field :provider, type: String
  field :uid, type: String
  field :name, type: String
  field :email, type: String

  def self.create_with_omniauth(auth)
    # copied from
    # http://railsapps.github.io/tutorial-rails-mongoid-omniauth.html
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
        user.name = auth['info']['name'] || ""
        user.email = auth['info']['email'] || ""
      end
    end
  end

  def generate_auth_token
    payload = {
        user_id: self._id.to_s,
        name: self.name
    }
    AuthToken.encode(payload)
  end
end

