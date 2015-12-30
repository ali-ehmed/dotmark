class StudentMailer < Devise::Mailer   
	helper :application # gives access to all helpers defined within `application_helper`.
	# include DecryptedHash
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  # default template_path: 'students/mailer' # to make sure that your mailer uses the devise views

	default from: 'notifications@dotmark.com'

  def confirmation_instructions(record, token, opts={})
  	if record.first_name.blank? and record.last_name.blank?
  		@full_name =  "Test Student # #{record.id}"
  	else
  		@full_name = record.full_name
  	end
	  headers["Custom-header"] = "Bar"
	  opts[:from] = 'donotreply@dotmark.com'
	  opts[:reply_to] = 'donotreply@dotmark.com'
	  super
	end

	def account_access(student)
		@resource = student
		@full_name = @resource.full_name
		@login_email = "#{@resource.email}"
		@login_username = "#{@resource.username}"
		@login_password = "#{DecryptedHash.new.decrypt_hash(@resource.temp_password)}"
		
		@login_url = students_login_after_confirmation_url(resource: @resource, subdomain: "#{@resource.account.subdomain}")
    mail(to: @resource.email, subject: 'Account Credentials')
	end
end
