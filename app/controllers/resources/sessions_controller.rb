class Resources::SessionsController < Devise::SessionsController
  # GET /resource/sign_in
  # before_action :require_account!, :except => [:new]
  # skip_before_action :require_account!
  # skip_before_filter :verify_authenticity_token, :only => :create
  def new
    @student_name = @account["resource"]["username"]
    super
  end

  def create
  	super
  end

  # DELETE /resource/sign_out
  def destroy
    resource = current_resource
    sign_out(resource_name)
    flash[:notice] = "Logged out successfully"
    redirect_to send("#{resource.class.to_s.underscore.pluralize}_login_url", subdomain: resource.account.subdomain)
  end

  def login_after_confirmation
    username = params[:resource]

    if student_resource
      @resource = Student.find_by_username username
    elsif teacher_resource
      @resource = Teacher.find_by_username username
    end

    sign_in(@resource.account.resource_type.downcase!, @resource)
    redirect_to send("#{@resource.class.to_s.underscore}_authenticated_root_path", subdomain: @resource.account.subdomain)
    flash[:notice] = "Signed in successfully"
  end
end