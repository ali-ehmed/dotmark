class NotificationMailer < ApplicationMailer
	def send_allocation_instructions(teacher, allocations)
		@teacher = teacher
		@allocations = allocations
		mail(to: @teacher.email, subject: 'Allocation Instructions')
	end
end
