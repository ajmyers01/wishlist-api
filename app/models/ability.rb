# frozen_string_literal: true
class Ability
  include CanCan::Ability

  # Initializes authorization for the provided user.
  def initialize(user)
    if user&.admin?
      admin
    elsif user&.viewer?
      viewer
    else
      # If a user was not provided or has no defined role,
      # then the user should not be able to access anything.
      cannot :manage, :all
    end
  end

  # Defines the abilities for an admin user.
  def admin
    can :manage, :all
  end

  # Defines the abilities for a viewer user.
  def viewer
    admin
  end
end
