# frozen_string_literal: true
class UsersController < ApplicationController
  # GET /users
  def index
    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  def disable
    @user = User.find_by(id: params[:id])

    if @user.update_attributes(user_status_id: UserStatus::DISABLED)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def enable
    @user = User.find_by(id: params[:id])

    if @user.update_attributes(user_status_id: UserStatus::ACTIVE)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def invite
    if User.where(email: user_params[:email].try(:strip).try(:downcase)).present?

      render json: { error: 'Email already exists' }, status: :unprocessable_entity
    else

      @user = User.new(
        email: user_params[:email].try(:strip).try(:downcase),
        first_name: user_params[:first_name].try(:strip).try(:humanize),
        last_name: user_params[:last_name].try(:strip).try(:humanize),
        password: "Temp#{User.generate_urlsafe}!",
        user_status_id: UserStatus::INVITED,
        user_role_id: params[:user][:user_role_id],
        invitation_code: User.generate_urlsafe
      )

      if @user.save
        # Send invitation email
        data = Hash.new { |hash, key| hash[key] = [] }
        data[:to] = @user.email
        data[:subject] = 'Subject'
        data[:html] = ActionController::Base.new.render_to_string('users/invitation',
                                                                  layout: 'mailer', locals: { user: @user }).to_str

        MailgunMailer.prepare(data).deliver_now
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end
  end

  def invite_signup
    if params[:code].present?
      @user = User.find_by(invitation_code: params[:code],
                           user_status_id: UserStatus::INVITED)
      if @user
        @user.update_attributes(user_status_id: UserStatus::ACTIVE)
        @user.generate_authentication_token!
        @user.save
        render json: @user.as_json(only: [:id, :first_name, :last_name, :email, :auth_token, :user_role_id, :user_status_id])
      else
        render json: { error: 'User Account is already active.' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid code' }, status: :unprocessable_entity
    end
  end

  def resend_invite
    @user = User.find_by(id: params[:id],
                         user_status_id: UserStatus::INVITED)

    if @user
      # Resend invitation email
      data = Hash.new { |hash, key| hash[key] = [] }
      data[:to] = @user.email
      data[:subject] = 'Subject'
      data[:html] = ActionController::Base.new.render_to_string('users/invitation',
                                                                layout: 'mailer', locals: { user: @user }).to_str

      MailgunMailer.prepare(data).deliver_now

      render json: { success: true }
    else
      render json: { error: 'An Error Occurred' }, status: :unprocessable_entity
    end
  end

  # :nocov:
  def send_password_reset
    @user = User.find_by(email: params[:email])
    if @user
      if @user.update_attributes(password_reset_token: User.generate_code, password_reset_sent_at: DateTime.now)
        data = Hash.new { |hash, key| hash[key] = [] }
        data[:to] = @user.email
        data[:subject] = 'Password Reset'
        data[:html] = ActionController::Base.new.render_to_string(template: 'users/password_reset',
                                                                  layout: 'mailer',
                                                                  locals: { user: @user }).to_str

        MailgunMailer.prepare(data).deliver_now
        render json: { success: true }
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Email is not present in our system' }, status: :unprocessable_entity
    end
  end

  def update_password
    @user = User.find_by(password_reset_token: params[:token])
    if @user.present?
      if @user.update_attributes(password: params[:password])
        @user.update_attributes(password_reset_token: nil)
        render json: { success: true }
      else
        render json: { error: 'Error Updating Your Password' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'This token has expired please try again.' }, status: :unprocessable_entity
    end
  end
  # :nocov:

  private

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation,
      :password_reset_token,
      :password_reset_sent_at,
      :user_role_id,
      :user_status_id
    )
  end
end
