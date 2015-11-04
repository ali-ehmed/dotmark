class Admins::SessionsController < Devise::SessionsController
  # GET /resource/sign_in
  def new
    super
  end

  def create
  	if @account.blank?
  		flash[:error] = "This area is not available for <strong>Unauthorized Users.</strong>"
  		self.resource = ""
  		render :new and return
  	end
  	super
  end
end