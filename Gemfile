source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.1'
gem 'mysql2', '>= 0.3.18', '< 0.5'
gem 'puma', '~> 3.0'
gem 'unicorn'
gem 'capistrano-rails'
gem 'capistrano-rvm'
gem 'capistrano-unicorn-nginx'
gem 'bcrypt'
gem 'cancancan'
gem 'rack-cors', :require => 'rack/cors'
gem 'will_paginate', '~> 3.1.0'
gem 'paranoia', '~> 2.2'
gem 'mailgun_rails'

# TODO: Eventually figure out why this cannot live inside the development group
gem 'listen', '~> 3.0.5'
gem 'factory_girl_rails', '~> 4.0'
gem 'faker'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry'
  gem 'better_errors'
end

group :development, :test do
  gem 'simplecov', :require => false
end


group :development do
  gem 'rubocop'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
