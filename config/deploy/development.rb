# frozen_string_literal: true
# This is the SSH port
#set :port, 8080

# This is the user to deploy as
set :user, 'jenkins'

# This is the branch to be deployed(develop, release, or master)
set :branch, 'develop'
set :deploy_via, :remote_cache
set :use_sudo, false
set :port, 22

# This is the server to deploy to
       server ENV['DEVELOPMENT_SERVER_IP'],
       roles: %w(web app db),
       port: fetch(:port),
       user: fetch(:user),
       primary: true

# This is the path the application is to be deployed to. If the server is
# to contain multiple environment deployments, put the application in respective
# environment folders (eg. apps/development/.., apps/test/..)
set :deploy_to, "/home/#{fetch(:user)}/apps/development/#{fetch(:application)}"

set :ssh_options, forward_agent: true,
    auth_methods: %w(publickey),
    user: 'jenkins'

# The rails environment to use (development, test, production)
set :rails_env, :development
set :conditionally_migrate, true
