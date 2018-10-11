# frozen_string_literal: true
class UserRolesController < ApplicationController
  # GET /user_roles
  def index
    render json: @user_roles
  end
end
