class ApplicationMailer < ActionMailer::Base
  default from: "dotmark@example.com"
  layout 'mailer'
  default template_path: 'mailer'

  def welcome_email(resource)
    @resource = resource
    mail(to: @resource.email, subject: 'Welcome to Dot Mark')
  end
end
