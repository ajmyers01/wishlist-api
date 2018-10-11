require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'should login' do
    user = create(:admin_user)

    post sessions_url,
         params: {
           session: {
             email: user.email,
             password: 'Password1!'
           }
         },
         as: :json

    assert_response :success
  end

  test 'should not login with invalid password' do
    user = create(:admin_user)

    post sessions_url,
         params: {
           session: {
             email: user.email,
             password: 'WrongPassword!'
           }
         },
         as: :json

    assert_response :unprocessable_entity
  end

  test 'inactive user should not login' do
    user = create(:inactive_viewer_user)

    post sessions_url,
         params: {
           session: {
             email: user.email,
             password: 'Password1!'
           }
         },
         as: :json

    assert_response :unprocessable_entity
  end

end
