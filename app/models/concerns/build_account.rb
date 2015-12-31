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
  	account = Account.find_by(subdomain: self.username)
  	if account
  		errors.add(:base, "'#{content_tag(:strong, account.subdomain)}' This username is already registered as a Subdomain".html_safe)
  	end
  end
end