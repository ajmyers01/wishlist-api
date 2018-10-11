# frozen_string_literal: true
class SessionsController < ApplicationController
  skip_load_and_authorize_resource

  skip_before_action :authenticate_with_token

  # POST /sessions
  def create
    password = params[:session][:password]
    email = params[:session][:email]
    user = email.present? && User.find_by(email: email)

    # Authenticate using bcrypt. User must be currently active
    # and pass authentication to be able to login.
    if user.active? && user&.authenticate(password)
      user.generate_authentication_token!
      user.save
      render json: user.as_json(only: [:id, :first_name, :last_name, :email, :auth_token, :user_role_id, :user_status_id])
    else
      render json: { errors: 'Invalid email or password' }, status: :unprocessable_entity
    end
  end

  #  DELETE /sessions/:auth_token
  def destroy
    user = User.find_by(auth_token: params[:id])
    user&.generate_authentication_token!
    user&.save
    head :no_content
  end
end
