class Admins::SessionsController < Devise::SessionsController
  # skip_before_filter :verify_authenticity_token
  # GET /resource/sign_in
  # skip_before_action :require_account!

  def new
    super
  end

  def create
    if @account.blank?
      flash[:error] = "This area is not available for <strong>Unauthorized Users.</strong>"
      self.resource = ""
      render :new and return
    end

    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?
    redirect_to admin_authenticated_root_path(subdomain: self.resource.account.subdomain)
  end
end