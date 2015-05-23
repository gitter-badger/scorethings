class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::Token

  field :username, type: String
  field :description, type: String
  embeds_one :auth_provider

  has_many :scores, autosave: true, dependent: :delete
  has_many :score_lists, autosave: true, dependent: :delete

  validates_presence_of :username
  validates_length_of :description, maximum: 150
  validates_format_of :username, with: /\A[a-z0-9_-]{3,16}\z/

  token :contains => :fixed_numeric, :length => 8
  search_in :username, :description

  def to_builder
    Jbuilder.new do |user|
      user.username self.username
      user.description self.description
      user.id self._id.to_s
      if self.auth_provider.public?
        user.auth_provider self.auth_provider.to_builder
      end
    end
  end

  def create_score(score)
    score.user = self
    self.scores << score

    if has_score_list_with_thing_filter(score.thing)
      add_score_to_any_score_list_with_with_thing_filter(score)
    else
      create_new_score_list_for_score(score)
    end

    score.reload
  end

  def create_score_list(attrs)
    score_list = ScoreList.new(attrs)
    self.score_lists << score_list
    score_list.save
    score_list
  end

  def create_new_score_list_for_score(score={})
    score_list = ScoreList.build_score_list_from_score(score)
    self.score_lists << score_list
    score_list
  end

  def has_score_list_with_thing_filter(thing={})
    !ScoreList.where(user: self, 'things.id' => thing._id).first.nil?
  end

  def add_score_to_any_score_list_with_with_thing_filter(score)
    thing = score.thing
    !ScoreList.where(user: self, 'things.id' => thing._id).each do |score_list|
      score_list.scores << score
    end
  end


  # TODO create method on ScoreList to restrict adding/removing scores not owned by user?
  # rather than on user?  security vulnerability?
  def add_score_to_score_list(score_list, score)
    if self != score_list.user
      raise Exceptions::UnauthorizedModificationError
    end

    score_list.scores << score
  end

  def remove_score_from_score_list(score_list, score)
    if self != score_list.user
      raise Exceptions::UnauthorizedModificationError
    end

    score_list.scores.delete(score)
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
    # copied from
    # http://railsapps.github.io/tutorial-rails-mongoid-omniauth.html

    create! do |user|
      if auth[:provider] == 'twitter'
        auth_provider = AuthProvider.create_twitter_provider(auth)
        if !auth_provider.valid?
          # TODO is this a security issue, the full error messages?  too much disclosure of information for hackers?
          # raise AuthenticationFailureError "failed to create user with omniauth provider: #{provider.errors.full_message}"
          raise Exceptions::AuthenticationFailureError
        end
        user.username = auth_provider.handle
        user.auth_provider = auth_provider
      else
        raise Exceptions::AuthenticationFailureError
      end
    end
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

