require 'test_helper'

class UserStatusTest < ActiveSupport::TestCase
  test 'user status is not valid' do
    user_status = UserStatus.create

    assert_not user_status.valid?
    assert_empty user_status.errors.keys - [:name]
  end

  test 'valid user status' do
    user_status = UserStatus.new(name: 'Active')
    assert user_status.valid?
  end
end
