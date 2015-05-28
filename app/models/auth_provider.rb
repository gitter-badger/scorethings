class AuthProvider
  include Mongoid::Document
  include Mongoid::Search

  field :uid, type: String
  field :handle, type: String
  field :type, type: String
  field :public, type: Boolean, default: false
  embedded_in :user

  validates_presence_of :uid, :handle, :type
  # TODO figure out how to validate that type is only 'twitter' or 'google',
  # or whatever omniauth providers

  search_in :handle


  def to_builder
    Jbuilder.new do |auth_provider|
      # TODO is this a mistake/security bug?  Should this never be allowed?  I have a check in the
      # user.to_builder, but should there also be one here, no no to_builder at all?
      # I don't think it is a bug to know someone's user id and handle, but it might be more
      # more info then they
      auth_provider.uid self.uid unless !self.public?
      auth_provider.handle self.handle unless !self.public?
      auth_provider.type self.type unless !self.public?
    end
  end

  def self.build_auth_provider(auth)
    # TODO special error messages, or would that expose security info for hackers?
    auth_uid = auth[:uid]
    if auth_uid.nil?
      raise Exceptions::AuthenticationFailureError
    end

    auth_info = auth[:info]
    if auth_info.nil?
      raise Exceptions::AuthenticationFailureError
    end

    auth_handle = auth_info[:nickname] || auth_info[:name]
    if auth_handle.nil?
      raise Exceptions::AuthenticationFailureError
    end

    auth_provider = auth[:provider]
    if auth_handle.nil?
      raise Exceptions::AuthenticationFailureError
    end

    AuthProvider.new(
      type: auth_provider,
      uid: auth_uid,
      handle: auth_handle
    )
  end
end
