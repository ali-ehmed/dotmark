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
#  temp_password          :text
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  address                :text
#

class Teacher < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
         
	has_many :course_allocations, dependent: :destroy
	has_many :allocated_sections, class_name: "CourseAllocation", foreign_key: :teacher_id
	
	has_one :account, as: :resource, dependent: :destroy
	has_one :avatar, as: :resource, class_name: "ResourceAvatar", foreign_key: :resource_id
  accepts_nested_attributes_for :avatar

	scope :present, -> { where("is_present = ?", true) }

	include BuildAccount

	attr_accessor :full_name
	attr_accessor :password_validity, :email_validity, :login

	before_create :set_employee_number, :default_values, :set_account, :generate_password
	after_create :send_welcome_email, :creating_joining_date

	before_validation :build_username
	validate :validates_subdomain, on: :create

	# validates_presence_of :first_name, :last_name, :on => :create
  validates_presence_of :first_name, :last_name, :username, :email, on: :update, if: :email_validity?

	def set_employee_number
		initialize_emp_number = self.class.last.blank? ? 1 : self.class.last.employee_number.to_i + 1 
		self.employee_number = "%03d" % initialize_emp_number.to_s
	end

	def has_room_scheduled?(batch_id, slot_id)
		course_allocations.where(batch_id: batch_id).joins(:time_tables).where("time_tables.time_slot_id = ?", slot_id)
	end

	def full_name
		"#{first_name} #{last_name}"
	end

	def allocations(batch_id, course_ids)
		course_allocations.where("batch_id = ? and course_id in (?)", batch_id, course_ids)
	end

	def sections_by_course(course_id, status)
		allocated_sections.where(course_id: course_id).where(status: status)
	end

	def skills
		read_attribute(:skills).blank? ? "---" : read_attribute(:skills)
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

	def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(conditions).where(["username = :value or email = :value", { :value => login }]).first
    else
      where(conditions.to_hash).first
    end
  end

  def under_approval_allocations(batch_id = "")
  	allocs = course_allocations.select("teacher_id, batch_id, course_id, semester_id, status")
  										.under_approval
  										.group("status, teacher_id, batch_id, course_id, semester_id")

		allocs = allocs.where(batch_id: batch_id) if batch_id.present?

		allocs
  end

  def is_present?
  	if is_present
  		"Yes"
  	else
  		"No"
  	end
  end

	private

	def build_username
		self.username = self.email.split("@").first
	end

	def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil? if self.password_validity == true
  end

	def default_values
		self.is_present = true
		self.first_name = "dotmark" if first_name.blank?
		self.last_name = "-teacher-#{employee_number}" if last_name.blank?		
	end

	def creating_joining_date
		if self.joining_date.blank?
	    self.joining_date = created_at
	    self.save!
	  end
  end
end
