class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::Token

  field :username, type: String
  field :description, type: String
  field :default_points, type: Integer, default: 75

  embeds_one :auth_provider

  has_many :scores, autosave: true, dependent: :delete

  validates_presence_of :username
  validates_uniqueness_of :username
  validates_format_of :username, with: /\A[A-Za-z0-9_-]{3,16}\z/
  validates_length_of :description, maximum: 150

  token :contains => :fixed_numeric, :length => 8
  search_in :username, :description

  def to_builder
    Jbuilder.new do |user|
      user.username self.username
      user.description self.description
      user.id self._id.to_s
      user.token self.token
    end
  end

  def create_score(score)
    score.user = self
    score.save!
    score
  end


  # TODO common logic between delete and change score
  def delete_score(score)
    if self != score.user
      raise Exceptions::UnauthorizedModificationError
    end
    score.destroy
  end

  def change_score(score, update_attrs)
    if self != score.user
      raise Exceptions::UnauthorizedModificationError
    end
    score.update_attributes!(update_attrs)
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      auth_provider = AuthProvider.build_auth_provider(auth)
      if !auth_provider.valid?
        # TODO is this a security issue, the full error messages?  too much disclosure of information for hackers?
        # raise AuthenticationFailureError "failed to create user with omniauth provider: #{provider.errors.full_message}"
        raise Exceptions::AuthenticationFailureError
      end
      random_username = User.generate_random_username
      user.username = random_username
      user.auth_provider = auth_provider
    end
  end

  def self.generate_random_username
    "user_#{Random.new.rand(0..30000000)}"
  end

  def self.find_by_omniauth(auth)
    # TODO is this a security issue, the reason why authentication failed?
    # too much disclosure of information for hackers?

    # TODO should there be a check that
    # the auth[:type] is only a valid type (twitter, google, etc.)?
    if auth.nil? || auth[:uid].nil? || auth[:provider].nil?
      raise Exceptions::AuthenticationFailureError
    end
    User.where('auth_provider.uid' => auth[:uid], 'auth_provider.type' => auth[:provider]).first
  end


  def generate_auth_token
    payload = {
        user_id: self._id.to_s,
        username: self.username
    }
    AuthToken.encode(payload)
  end
end

