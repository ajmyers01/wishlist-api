# Seed user tables
Rake::Task['tool:seed_user_roles'].invoke
Rake::Task['tool:seed_user_statuses'].invoke
Rake::Task['tool:seed_users'].invoke
