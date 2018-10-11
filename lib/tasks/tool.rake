# frozen_string_literal: true
namespace :tool do
  task seed_users: :environment do
    names = %w(admin dev.alex.myers)

    names.each do |name|
      email = "#{name}@gmail.com"
      fragments = name.split '.'

      # Skip any users that already exist.
      next if User.exists?(email: email)

      puts "Seeding user: #{email}"

      User.create(first_name: fragments[0].capitalize,
                  last_name: (fragments[1] || 'user').capitalize,
                  email: email,
                  password: 'Password1!',
                  user_status_id: UserStatus::ACTIVE,
                  user_role_id: UserRole::ADMIN)
    end
  end
  task seed_user_statuses: :environment do
    status = [{ id: UserStatus::ACTIVE, name: 'Active' },
             { id: UserStatus::INVITED, name: 'Invited' },
             { id: UserStatus::DISABLED, name: 'Disabled' }]

    status.each do |s|
      next if UserStatus.exists?(id: s[:id])

      puts "Seeding user status: #{s[:name]}"

      UserStatus.create(s)
    end
  end

  task seed_user_roles: :environment do
    roles = [{ id: UserRole::ADMIN, name: 'Admin' },
             { id: UserRole::VIEWER, name: 'Viewer' }]

    roles.each do |role|
      next if UserRole.exists?(id: role[:id])

      puts "Seeding user role: #{role[:name]}"

      UserRole.create(role)
    end
  end
end
