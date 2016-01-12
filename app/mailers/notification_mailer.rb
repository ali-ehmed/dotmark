class NotificationMailer < ApplicationMailer
	default template_path: 'notification_mailer'
	def send_allocation_instructions(teacher, allocations)
		@teacher = teacher
		@allocations = allocations
		@teacher_dashboard_url = teachers_login_url(resource: @teacher.username, subdomain: "#{@teacher.account.subdomain}")
		$redis.del("teacher_allocations")
		mail(to: @teacher.email, subject: 'Allocation Instructions')
	end
end
