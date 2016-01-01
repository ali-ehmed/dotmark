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
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  temp_password          :text
#

class Student < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  include BuildAccount

  belongs_to :section
  belongs_to :semester
  belongs_to :batch
  has_one :parent
  has_one :parent, through: :guardian_relation

  has_one :account, as: :resource, dependent: :destroy
  has_many :notifications, as: :resource

  scope :current_batches, -> { joins(:batch).where("batches.name like ?", "#{Time.now.year - 5}%") }

  attr_accessor :password_validity, :email_validity, :login

  validates_presence_of :section, :batch
  validates_presence_of :first_name, :last_name, :username, :email, if: :email_validity?
  validates :username,
    :presence => true,
    :uniqueness => {
      :case_sensitive => false
    }, if: :email_validity?

  validate :validates_subdomain, on: :create, if: :email_validity?
    
  before_create :set_account
  after_create :generate_password
  after_create :creating_joining_date, :send_welcome_email
  after_initialize :default_values

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

    def search(params)
      if params[:batch_id_param].present?
        @batch = Batch.find(params[:batch_id_param])
        @students = nil
        if params[:student_name].present?
          @students = @batch.students.where("first_name || ' ' || last_name LIKE ?", "%#{params[:student_name]}%") 
        elsif params[:student_name].present? and params[:roll_no].present?
          @students = @batch.students.where("first_name || ' ' || last_name LIKE ? and roll_number = ?", "%#{params[:student_name]}%", params[:roll_no]) 
        elsif params[:student_name].present? and params[:roll_no].present? and params[:student_section].present?
          @students = @batch.students.where("first_name || ' ' || last_name LIKE ? and roll_number = ? and section_id = ?", "%#{params[:student_name]}%", params[:roll_no], params[:student_section])
        elsif params[:roll_no].present?
          @students = @batch.students.where("roll_number = ?", params[:roll_no])
        elsif params[:student_section].present?
          @students = @batch.students.where("section_id = ?", params[:student_section])
        end
        @students ||= @batch.students
        logger.debug @students.count
      end

      return @students, @batch
    end
	end

  def email_validity?
    email_validity == true
  end

  def password_validity?
    password_validity == true
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def send_welcome_email
    ApplicationMailer.welcome_email(self).deliver_now!
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
      AccountMailer.account_access(self).deliver_now!
    end
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(conditions).where(["username = :value or email = :value", { :value => login }]).first
    else
      where(conditions.to_hash).first
    end
  end

  def passed_out
    if read_attribute(:passed_out) == true
      "Yes"
    else
      "No"
    end
  end

  private

  # Set Validities of devise
  def email_required?
    true if self.email_validity?
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil? if self.password_validity?
  end

  def default_values
    self.passed_out ||= false
    self.roll_number ||= "#{self.batch.try(:batch_name)}-CS-#{self.class.last.present? ? (self.class.last.id.to_i + 1).to_s : '1'}"
    self.semester = Semester.first_semester if self.semester_id.blank?

    disable_authentication_fields
  end

  def generate_password
    rand_string = self.generate_random_string

    attributes = {
      :password => rand_string, 
      :password_confirmation => rand_string, 
      :temp_password => rand_string
    }
    self.password = attributes[:password]
    self.password_confirmation = attributes[:password_confirmation]

    cipher_key = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
    encryted_temp_password = cipher_key.encrypt_and_sign(attributes[:temp_password])
    
    self.temp_password = encryted_temp_password
  end

  def creating_joining_date
    self.joining_date = created_at
    self.save!
  end

  # Used when initializing
  def disable_authentication_fields
    self.email_validity == false
    self.password_validity == false
  end
end
