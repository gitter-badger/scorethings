class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::Token

  embeds_one :auth_provider

  field :username, type: String
  field :description, type: String

  search_in :username, :description

  validates_presence_of :username
  validates_uniqueness_of :username
  validates_format_of :username, with: /\A[A-Za-z0-9_-]{3,16}\z/
  validates_length_of :description, maximum: 300

  has_many :scores, autosave: true, dependent: :delete

  token :contains => :fixed_numeric, :length => 8

  def to_builder
    Jbuilder.new do |user|
      user.username self.username
      user.id self._id.to_s
      user.token self.token
    end
  end

  def create_score(score)
    existing_score = self.scores.where(thing: score.thing, criterion: score.criterion).first
    unless existing_score.nil?
      raise Exceptions::ScoreNotUniqueError.new(existing_score)
    end
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

  def update_points(score, points)
    if self != score.user
      raise Exceptions::UnauthorizedModificationError
    end
    score.update_points(points)
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      auth_provider = AuthProvider.build_auth_provider(auth)
      if !auth_provider.valid?
        # TODO is this a security issue, the full error messages?  too much disclosure of information for hackers?
        # raise AuthenticationFailureError "failed to create user with omniauth provider: #{provider.errors.full_message}"
        raise Exceptions::AuthenticationFailureError
      end

      user.username = User.generate_random_username
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
        username: self.username,
    }
    AuthToken.encode(payload)
  end
end

