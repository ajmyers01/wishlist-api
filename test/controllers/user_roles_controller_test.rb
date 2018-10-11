require 'test_helper'

class UserRolesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get user_roles_url,
        headers: admin_header,
        as: :json

    assert_response :success
  end
end
