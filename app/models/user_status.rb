# frozen_string_literal: true
class UserStatus < ApplicationRecord
  # :nocov:
  has_many :users
  validates_presence_of :name

  ACTIVE = 1
  INVITED = 2
  DISABLED = 3
  # :nocov:
end
