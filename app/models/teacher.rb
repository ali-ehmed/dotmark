# == Schema Information
#
# Table name: teachers
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  gender                 :string
#  date_of_birth          :date
#  joining_date           :date
#  qualification          :text
#  past_experience        :string
#  phone                  :string
#  skills                 :string
#  is_present             :boolean
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  employee_number        :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  username               :string
#

class Teacher < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	has_many :course_allocations
	has_many :allocated_sections, class_name: "CourseAllocation", foreign_key: :teacher_id
	has_one :account, as: :resource

	scope :present, -> { where("is_present = ?", true) }

	include BuildAccount

	attr_accessor :teacher_password, :full_name

	before_create :set_employee_number, :default_values
	after_create :set_account

	def set_employee_number
		initialize_emp_number = self.class.last.blank? ? 1 : self.class.last.employee_number.to_i + 1 
		self.employee_number = "%03d" % initialize_emp_number.to_s
	end

	def full_name
		"#{first_name} #{last_name}"
	end

	def allocations(batch_id, course_id)
		course_allocations.where("batch_id = ? and course_id = ?", batch_id, course_id)
	end

	def sections_by_course(course_id)
		allocated_sections.where(course_id: course_id)
	end

	def full_name=(value)
		full_name = value.split(" ")
		if full_name.length == 1
			set_last_name = ""
		elsif full_name.length > 2
			full_name.shift
			set_last_name = full_name.join(" ")
		else
			set_last_name = full_name.last
		end
		self.first_name = value.split(" ").first
		self.last_name = set_last_name
	end

	def self.search(params)
    if params[:teacher_name].present?
      @teachers = where("first_name || ' ' || last_name LIKE ?", "%#{params[:teacher_name]}%") 
    elsif params[:teacher_name].present? and params[:employee_no].present?
      @teachers = where("first_name || ' ' || last_name LIKE ? and employee_number = ?", "%#{params[:teacher_name]}%", params[:employee_no]) 
    elsif params[:employee_no].present?
      @teachers = where("employee_number = ?", params[:employee_no])
    # elsif params[:teacher_courses].present?
    #   @students = @batch.students.where("course_id = ?", params[:teacher_courses])
    end
    @teachers ||= present

	  return @teachers
	end

	def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil? if teacher_password == true
  end

  def is_present?
  	if is_present
  		"Yes"
  	else
  		"No"
  	end
  end

	private

	def default_values
		self.is_present = true
		self.first_name = "dotmark" if first_name.blank?
		self.last_name = "-teacher-#{employee_number}" if last_name.blank?
		self.username = self.email.split("@").first
	end
end
