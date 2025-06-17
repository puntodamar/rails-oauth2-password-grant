class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable

  enum role: { user: 0, admin: 1 }

  has_many :oauth_access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  has_many :oauth_access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all


  def allowed_scopes
    scopes = []
    scopes += %w[web] if has_web_access?
    scopes += %w[api] if has_api_access?
    scopes += %w[mobile] if has_mobile_access?
    scopes += %w[admin] if admin?
    scopes
  end

  def has_web_access?
    # logic based on profile/setting
  end

  def has_api_access?
    # logic based on profile/setting
  end

  def has_mobile_access?
    # logic based on profile/setting
  end

end
