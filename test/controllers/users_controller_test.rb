require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get users_url,
        headers: admin_header,
        as: :json

    assert_response :success
  end

  test 'should get not index' do
    get users_url,
      as: :json

    assert_response 401
  end

  test 'should create user' do
    header = admin_header

    assert_difference('User.count') do
      post users_url,
           params: {
             user: {
               email: Faker::Internet.email,
               first_name: Faker::Name.first_name,
               last_name: Faker::Name.last_name,
               password: 'Password1!',
               password_confirmation: 'Password1!',
               user_role_id: UserRole::ADMIN
             }
           },
           headers: header,
           as: :json
    end

    assert_response :created
  end

  test 'should not create user' do
    header = admin_header

    assert_no_difference('User.count') do
      post users_url,
        params: {
        user: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
        }
      },
      headers: header,
      as: :json
    end

    assert_response 422
  end

  test 'should show user' do
    get user_url(create(:admin_user)),
        headers: admin_header,
        as: :json

    assert_response :success
  end

  test 'should update user' do
    patch user_url(create(:admin_user)),
          params: {
            user: {
              email: Faker::Internet.email,
              first_name: Faker::Name.first_name,
              user_status_id: UserStatus::ACTIVE,
              last_name: Faker::Name.last_name
            }
          },
          headers: admin_header,
          as: :json

    assert_response :success
  end

  test 'should not update user' do
    patch user_url(create(:admin_user)),
          params: {
            user: {
              email: nil,
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name
            }
          },
          headers: admin_header,
          as: :json

    assert_response 422
  end

  test 'should disable user' do
    user = create(:viewer_user)
    patch disable_user_url(create(:admin_user)),
          params: {
            id:  user.id,
          },
          headers: admin_header,
          as: :json

    assert_response 200
  end

  test 'should enable user' do
    user = create(:viewer_user)
    patch enable_user_url(create(:admin_user)),
          params: {
            id:  user.id,
          },
          headers: admin_header,
          as: :json

    assert_response 200
  end

  test 'should invite user' do
    header = admin_header

    assert_difference('User.count', 1) do
      post invite_users_url,
        params: {
        user: {
          email: "test@email.com",
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          user_role_id: 1,
        }
      },
      headers: header,
      as: :json
    end
  end

  test 'should not invite user' do
    header = admin_header

    assert_no_difference('User.count') do
      post invite_users_url,
        params: {
        user: {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          user_role_id: 1,
        }
      },
      headers: header,
      as: :json
    end

    assert_response 422
  end

  test 'should not invite user already in system' do
    header = admin_header
    user = create(:viewer_user)

    assert_no_difference('User.count') do
      post invite_users_url,
        params: {
        user: {
          email: user.email,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          user_role_id: 1,
        }
      },
      headers: header,
      as: :json
    end

    assert_response 422
  end

  test 'should complete invited user signup' do
    header = admin_header
    invited_user = create(:invited_user)

    post invite_signup_users_url,
      params: {
      user: invited_user,
      code: invited_user.invitation_code,
    },
    headers: header,
    as: :json

    response = eval(@response.body)
    assert_equal(response.dig(:user_status_id), 1)
  end

  test 'should not allow already active users to hit signup action' do
    header = admin_header
    invited_user = create(:viewer_user)

    post invite_signup_users_url,
      params: {
      user: invited_user,
      code: invited_user.invitation_code,
    },
    headers: header,
    as: :json

    assert_response 422
  end

  test 'should destroy user' do
    header = admin_header
    user = create(:viewer_user)

    assert_difference('User.count', -1) do
      delete user_url(user),
             headers: header,
             as: :json
    end

    assert_response :no_content
  end
end
