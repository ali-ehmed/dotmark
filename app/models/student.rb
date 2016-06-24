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
  has_one :avatar, as: :resource, class_name: "ResourceAvatar", foreign_key: :resource_id
  accepts_nested_attributes_for :avatar

  has_many :notifications, as: :resource

  scope :current_batches, -> (batch = "") {joins(:batch).where("batches.name like ?", "#{batch.blank? ? Time.now.year : batch}%") }

  attr_accessor :password_validity, :email_validity, :login

  validates_presence_of :section, :batch
  validates_presence_of :first_name, :last_name, :on => :create, if: :email_validity?
  validates_presence_of :first_name, :last_name, :username, :email, on: :update, if: :email_validity?
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
	end

  def full_name
    "#{first_name} #{last_name}"
  end

  def passed_out
    if read_attribute(:passed_out) == true
      "Yes"
    else
      "No"
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

  private

  # Set Validities of devise
  def email_required?
    true if email_validity?
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil? if password_validity?
  end

  def default_values
    self.passed_out ||= false
    self.roll_number ||= "#{self.batch.try(:batch_name)}-CS-#{self.class.last.present? ? (self.class.last.id.to_i + 1).to_s : '1'}"
    self.semester = Semester.first_semester if self.semester_id.blank?

    disable_authentication_fields
  end

  def creating_joining_date
    self.joining_date = created_at
    self.save!
  end
end
