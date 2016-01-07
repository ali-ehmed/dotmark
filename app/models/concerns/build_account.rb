module BuildAccount
	include ActionView::Helpers::TagHelper

	def set_account
    @account = build_account
    _subdomain = ""
    if self.class == Student
    	_subdomain = "#{self.username}.student"
    else
    	_subdomain = "#{self.username}.teacher"
    end
    @account.subdomain = _subdomain
    @account.save
  end

  def validates_subdomain
    if self.class == Student
      subdomain = "#{self.username}.student"
    elsif self.class == Teacher
      subdomain = "#{self.username}.teacher"
    end
  	account = Account.find_by(subdomain: subdomain)
  	if account.present?
  		errors.add(:base, "'#{content_tag(:strong, account.subdomain)}' This username is already registered as a Subdomain".html_safe)
  	end
  end

  def send_welcome_email
    ApplicationMailer.welcome_email(self).deliver_now!
  end

  def generate_random_string
    alphabets = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    random_string = (0...8).map { alphabets[rand(alphabets.length)] }.join
    random_string
  end

  def generate_password
    rand_string = generate_random_string

    attributes = {
      :password => rand_string, 
      :password_confirmation => rand_string, 
      :temp_password => rand_string
    }
    self.password = attributes[:password]
    self.password_confirmation = attributes[:password_confirmation]

    encryted_temp_password = StringEncryptor.new.encrypt_hash(attributes[:temp_password])
    
    self.temp_password = encryted_temp_password
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

  def email_validity?
    self.email_validity == true
  end

  def password_validity?
    self.password_validity == true
  end

  # Used when initializing
  def disable_authentication_fields
    self.email_validity == false
    self.password_validity == false
  end
end