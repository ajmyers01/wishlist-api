require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'user is not valid' do
    user = User.create

    assert_not user.valid?
    assert_empty user.errors.keys - [:user_role, :email, :first_name, :last_name, :password]
  end

  test '#viewer' do
    user = create(:viewer_user)
    assert_equal user.viewer?, true
    assert_equal user.admin?, false
  end

  test '#admin?' do
    user = create(:admin_user)
    assert_equal user.viewer?, false
    assert_equal user.admin?, true
  end
end
