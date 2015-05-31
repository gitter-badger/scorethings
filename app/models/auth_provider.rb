class AuthProvider
  include Mongoid::Document

  field :uid, type: String
  field :handle, type: String
  field :type, type: String
  field :public, type: Boolean, default: false
  embedded_in :user

  validates_presence_of :uid, :handle, :type

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
