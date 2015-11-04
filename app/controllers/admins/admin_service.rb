module AdminService
  def call
    admin = Admin.find_or_create_by!(email: Rails.application.secrets.admin_email) do |admin|
      admin.password = Rails.application.secrets.admin_password
      admin.password_confirmation = Rails.application.secrets.admin_password
      admin.is_admin = true
      # admin.confirm!
    end
  end

  def setting_admin_account
  	admin_user = call
  	@admin_account = admin_user.build_account
  	subdoamin_name = admin_user.email.split("@").first
  	@admin_account.subdomain = subdoamin_name
  	@admin_account.save
  end

  module_function :call, :setting_admin_account
end
