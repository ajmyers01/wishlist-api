# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  default from: 'dev.alex.myers@gmail.com'
  layout 'mailer'
end
