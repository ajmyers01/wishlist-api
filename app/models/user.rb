# frozen_string_literal: true
class User < ApplicationRecord
  # :nocov:
  has_secure_password
  belongs_to :user_status

  belongs_to :user_role

  validates_uniqueness_of :auth_token
  validates_presence_of :user_role, :email, :first_name, :last_name

  before_save :check_auth_token
  # :nocov:

  # Returns true if the user has the "Admin" user role.
  def admin?
    user_role_id == UserRole::ADMIN
  end

  # Returns true if the user has the "Viewer" user role.
  def viewer?
    user_role_id == UserRole::VIEWER
  end

  def active?
    user_status_id == UserStatus::ACTIVE
  end

  # :nocov:
  # Generates and assigns a new authentication token to the user.
  def generate_authentication_token!
    begin
      self.auth_token = SecureRandom.hex(20)
    end while self.class.exists?(auth_token: auth_token)
  end

  # Generates readable random code
  def self.generate_code(size = 12)
    charset = %w(2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z)
    begin
      code = (0...size).map { charset.to_a[rand(charset.length)] }.join
    end while User.exists?(password_reset_token: code)
    code
  end

  # Generates urlsafe invitation
  def self.generate_urlsafe(size = 30)
    begin
      code = SecureRandom.urlsafe_base64(size)
    end while User.exists?(invitation_code: code)
    code
  end
  # :nocov:

  private

  # Updates the auth token for a new user or when their active state changes.
  def check_auth_token
    generate_authentication_token! if new_record? || user_status_id_changed?
  end
end
