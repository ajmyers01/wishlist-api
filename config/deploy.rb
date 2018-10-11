# frozen_string_literal: true
# config valid only for current version of Capistrano
lock '3.8.0'

set :application, 'wishlist-api'
set :repo_url, 'git@github.com:ajmyers01/wishlist-api.git'
set :use_sudo, false
set :bundle_binstubs, nil
set :assets_roles, %w(web app)
set :linked_files, fetch(:linked_files, []).push('config/database.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :rvm_ruby_version, '2.3.1'

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
