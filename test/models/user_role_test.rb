require 'test_helper'

class UserRoleTest < ActiveSupport::TestCase
  test 'valid user role' do
    user_role = UserRole.new(name: 'Admin')
    assert user_role.valid?
  end

  test 'user role is not valid' do
    user_role = UserRole.create

    assert_not user_role.valid?
    assert_empty user_role.errors.keys - [:name]
  end
end
