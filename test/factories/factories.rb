FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password 'Password1!'

    factory :admin_user do
      user_role_id UserRole::ADMIN
      user_status_id UserStatus::ACTIVE
    end

    factory :invited_user do
      user_role_id UserRole::ADMIN
      user_status_id UserStatus::INVITED
      invitation_code {User.generate_urlsafe}
    end

    factory :viewer_user do
      user_role_id UserRole::VIEWER
      user_status_id UserStatus::ACTIVE

      factory :inactive_viewer_user do
        user_status_id UserStatus::DISABLED
      end
    end
  end
end
