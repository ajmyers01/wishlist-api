# frozen_string_literal: true
# Description: Send email format options

# data = Hash.new { |hash,key| hash[key] = [] }
# data[:to] = "email_to@test.com"
# data[:subject] = "Hello"
# data[:text] = "Testing some Mailgun awesomness!"
# data[:html] = "<html>HTML version of the body. <h1> thanks!!! </h1> </html>"
# data[:attachment] = File.new(File.join("files", "test.jpg"))
class MailgunMailer < ApplicationMailer
  def prepare(data)
    return 'Data not defined. Email was not sent.' unless data
    data[:from] = Rails.configuration.action_mailer.mailgun_settings[:from].to_s

    begin
      RestClient.post "#{Rails.configuration.action_mailer.mailgun_settings[:api_key]}"\
      "#{Rails.configuration.action_mailer.mailgun_settings[:domain]}", data
    rescue RestClient::ExceptionWithResponse => e
      puts e.response
    end
  end
end
