class Resource::SessionsController < Devise::SessionsController
  # GET /resource/sign_in
  # before_action :require_account!, :except => [:new]
  # skip_before_action :require_account!
  
  def new
    @student_name = @account.resource.username
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

  # We cannot use @account helper variable becuase, this actions will be handled after email confimation
  # So request.protocol or request.host cannot be found, therefore we used "resouce_param"

  def login_after_confirmation
    resource_param = params[:resource]
    case resource_param.class
    when Student
      @resource = Student.find_by_username resource_param.username
    when Teacher
      @resource = Teacher.find_by_username resource_param.username
    end
    sign_in(@resource.account.resource_type.downcase!, @resource)
    redirect_to send("#{resource_param.class.to_s.underscore.pluralize}_authenticated_root_path", subdomain: @resource.account.subdomain)
    flash[:notice] = "Signed in successfully"
  end
end