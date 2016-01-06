class ApplicationMailer < ActionMailer::Base
  default from: 'welcome@dotmark.com'
  default template_path: 'mailer'
  layout 'mailer'

  def welcome_email(user)
  	@resource = user
  	mail(to: @resource.email, from: "welcome@dotmark.com", subject: 'Welcome to Dotmark')
  end
end
