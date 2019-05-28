class ApplicationMailer < ActionMailer::Base
  default from: Settings.config.email
  layout 'mailer'
end