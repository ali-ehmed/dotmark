# == Schema Information
#
# Table name: admins
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  is_admin               :boolean          default(FALSE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string
#

class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  has_one :account, as: :resource
  after_create :set_account

  has_many :notifications, as: :resource
  
  attr_accessor :login

  validates :username,
	  :presence => true,
	  :uniqueness => {
	    :case_sensitive => false
	  } # etc.

 	def active_for_authentication?
	  super && self.is_admin # i.e. super && self.is_active
	end

	def inactive_message
	  "Sorry, this area is restricted for other users."
	end

	def is_admin?
		if is_admin == true then return true end
	end

	def set_account
		Admins::AdminService.new.setting_admin_account
	end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(conditions).where(["username = :value or email = :value", { :value => login }]).first
    else
      where(conditions.to_hash).first
    end
  end
end
