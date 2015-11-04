# == Schema Information
#
# Table name: students
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  roll_number            :string
#  phone                  :string
#  address                :text
#  date_of_birth          :date
#  joining_date           :date
#  passed_out             :boolean
#  passed_out_date        :date
#  section_id             :integer
#  batch_id               :integer
#  semester_id            :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  username               :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  gender                 :string
#  nationality            :string
#

class Student < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  belongs_to :section
  belongs_to :semester
  belongs_to :batch
  has_one :parent
  has_one :parent, through: :guardian_relation

  has_one :account, as: :resource

  attr_accessor :admission_session

  validates_presence_of :section, :semester, :batch
  validates_uniqueness_of :username, if: :check_admission_session
  
  after_create :creating_joining_date, :set_account, :creating_name_if_blank, :send_welcome_email
  before_validation :generate_password

  class << self
  	def build_admission(hash)
	  	admission = Student.new(:section_id => hash[:section],
	                            :batch_id => hash[:batch],
	                            :semester_id => hash[:semester])
	  	admission
	  end

    def enroll_new(params = nil)
      new(params)
    end
	end

	def email_required?
		true if admission_session == true
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil? if admission_session == true
  end

  def check_admission_session
    admission_session == true
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def send_welcome_email
    ApplicationMailer.welcome_email(self).deliver!
  end

  def set_account
    @account = build_account 
    @account.subdomain = username
    @account.save
  end

  def generate_random_string
    alphabets = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    random_string = (0...8).map { alphabets[rand(alphabets.length)] }.join
    random_string
  end

  def first_confirmation?
    previous_changes[:confirmed_at] && previous_changes[:confirmed_at].first.nil?
  end

  def confirm!
    super
    if first_confirmation?
      StudentMailer.account_access(self).deliver!
    end
  end

  private

  def generate_password
    rand_string = self.generate_random_string

    self.password = rand_string
    self.password_confirmation = rand_string
    temp_password = rand_string

    cipher_key = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
    encryt_temp_password = cipher_key.encrypt_and_sign(temp_password)
    self.temp_password = encryt_temp_password
  end

  def creating_joining_date
    self.joining_date = created_at
    self.save!
  end

  def creating_name_if_blank
    if first_name.blank? and last_name.blank?
      self.first_name = "dotmark.student-#{id}" 
      self.save!
    end
  end
end
