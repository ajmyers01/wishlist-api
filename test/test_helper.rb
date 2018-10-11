require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/test/'
  add_filter '/config/'
  add_filter '/app/channels/'
  add_filter '/app/jobs/'
  add_filter '/app/mailers/'
  add_filter '/app/models/application_record'
  add_filter '/app/controllers/application_*'
  add_filter '/bin/*'
  add_filter '/lib/*'

  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Helpers', 'app/helpers'
  add_group 'Libraries', 'lib'
  SimpleCov.refuse_coverage_drop
  SimpleCov.minimum_coverage 80
end

SimpleCov.at_exit do
  SimpleCov.result.format!
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Allow FactoryGirl methods to be called without prefix
  include FactoryGirl::Syntax::Methods

  # Add more helper methods to be used by all tests here...
  Rake::Task['tool:seed_user_roles'].invoke
  Rake::Task['tool:seed_user_statuses'].invoke

  def header(user)
    { AUTHORIZATION: user.auth_token }
  end

  def admin_header
    header(create(:admin_user))
  end

  def viewer_header
    header(create(:viewer_user))
  end
end
