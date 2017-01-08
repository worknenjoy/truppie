class ApplicationMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default from: "ola@truppie.com"
  layout 'mailer'
end
