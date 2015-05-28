class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::Token

  field :username, type: String
  field :description, type: String
  field :default_points, type: Integer, default: 0
  field :filter_obscenity, type: Boolean, default: true

  embeds_one :auth_provider

  has_many :scores, autosave: true, dependent: :delete
  has_many :score_lists, autosave: true, dependent: :delete

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

    add_score_to_any_score_list_with_thing_filter(score)
    score.reload
  end

  def create_score_list(attrs)
    score_list = ScoreList.new(attrs)
    self.score_lists << score_list
    score_list.save
    score_list
  end

  def create_new_score_list_for_score(score)
    score_list = ScoreList.build_score_list_from_score(score)
    score_list.user = self
    score_list
  end



  # TODO create method on ScoreList to restrict adding/removing scores not owned by user?
  # rather than on user?  security vulnerability?
  def add_score_to_score_list(score_list, score)
    if self != score_list.user || self != score.user
      raise Exceptions::UnauthorizedModificationError
    end

    score_list.scores << score
  end

  def remove_score_from_score_list(score_list, score)
    if self != score_list.user || self != score.user
      raise Exceptions::UnauthorizedModificationError
    end

    score_list.scores.delete(score)
    score_list
  end

  def add_thing_filter_to_score_list(score_list, thing)
    if self != score_list.user
      raise Exceptions::UnauthorizedModificationError
    end
    score_list.things << thing
    scores.where(thing: thing).each do |score_to_retroactively_add_to_score_list|
      score_list.scores << score_to_retroactively_add_to_score_list
    end
  end

  def remove_thing_filter_from_score_list(score_list, thing)
    if self != score_list.user
      raise Exceptions::UnauthorizedModificationError
    end
    score_list.things.delete(thing)
  end


  # TODO common logic between delete and change score
  def delete_score(score)
    if self != score.user
      raise Exceptions::UnauthorizedModificationError
    end
    score.destroy
  end

  def delete_score_list(score_list)
    if self != score_list.user
      raise Exceptions::UnauthorizedModificationError
    end
    score_list.destroy
  end

  def change_score(score, update_attrs)
    if self != score.user
      raise Exceptions::UnauthorizedModificationError
    end
    score.update_attributes(update_attrs)
  end

  def change_score_list(score_list, update_attrs)
    if self != score_list.user
      raise Exceptions::UnauthorizedModificationError
    end
    score_list.update_attributes(update_attrs)
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

  private
  def add_score_to_any_score_list_with_thing_filter(score)
    # TODO figure out correct way to do this, with querying
    # maybe data design is wrong, too normalized, too many relationships?
    self.score_lists.each do |score_list|
      if score_list.things.include? score.thing
        score_list.scores << score
      end
    end
  end
end

