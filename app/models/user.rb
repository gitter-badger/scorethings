class User
  include Neo4j::ActiveNode
  property :provider
  property :uid
  property :name
  property :email

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
        user_id: self.neo_id,
        name: self.name
    }
    AuthToken.encode(payload)
  end
end

