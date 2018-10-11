# frozen_string_literal: true
class ApplicationController < ActionController::API
  include Authenticable
  include CanCan::ControllerAdditions

  # Default to authenticate and authorize all resources. Specify
  # those that should skip this in their respective controllers.
  before_action :authenticate_with_token
  load_and_authorize_resource

  # Return a forbidden status with an error message on authorization exceptions
  rescue_from CanCan::AccessDenied do
    render json: { errors: 'Not authorized' },
           status: :forbidden
  end
end
