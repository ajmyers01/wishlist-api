# frozen_string_literal: true
namespace :ci do
  desc 'Continuous integration task'
  task run: [:minitest, :rubocop]

  task :minitest do
    sh 'bundle exec rake test RAILS_ENV=test'
  end

  task :rubocop do
    sh 'rubocop -D'
  end
end
