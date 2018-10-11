# frozen_string_literal: true
module Authenticable
  # Returns the current user by looking at the requests "Authorization" header.
  def current_user
    @current_user ||= User.find_by(
      user_status_id: UserStatus::ACTIVE,
      auth_token: request.headers['Authorization']
    )
  end

  # Authenticates the request and responds accordingly upon failure.
  def authenticate_with_token
    unless current_user.present?
      render json: { errors: 'Not authenticated' },
             status: :unauthorized
    end
  end
end
