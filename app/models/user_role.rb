# frozen_string_literal: true
class UserRole < ApplicationRecord
  # :nocov:
  has_many :users

  validates_presence_of :name

  ADMIN = 1
  VIEWER = 2
  # :nocov:
end
