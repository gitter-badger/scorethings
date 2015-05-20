class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # FIXME move twitter uid and handle(?) into new AuthProvider embeded doc
  # want to have multiple providers (Google, Facebook, SoundCloud, etc.)
  # allow user to link different accounts to one scorethings account
  field :twitter_uid, type: String
  field :twitter_handle, type: String

  has_many :scores, autosave: true
  has_many :score_lists, autosave: true

  def to_builder
    Jbuilder.new do |user|
      user.twitter_uid self.twitter_uid
      user.id self._id.to_s
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
  ``
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
      raise UnauthorizedModificationError
    end

    score_list.scores << score
  end

  def remove_score_from_score_list(score_list, score)
    if self != score_list.user
      raise UnauthorizedModificationError
    end

    score_list.scores.delete(score)
  end

  # TODO common logic between delete and change score
  def delete_score(score)
    if self != score.user
      raise UnauthorizedModificationError
    end
    score.destroy
  end

  def delete_score_list(score_list)
    if self != score_list.user
      raise UnauthorizedModificationError
    end
    score_list.destroy
  end

  def change_score(score, update_attrs)
    if self != score.user
      raise UnauthorizedModificationError
    end
    score.update_attributes(update_attrs)
  end

  def change_score_list(score_list, update_attrs)
    if self != score_list.user
      raise UnauthorizedModificationError
    end
    score_list.update_attributes(update_attrs)
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

