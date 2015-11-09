class Students::SessionsController < Devise::SessionsController
  # GET /resource/sign_in
  # before_action :require_account!, :except => [:new]
  # skip_before_action :require_account!
  
  def new
    @student_name = @account.resource.username
    super
  end

  def create
  	if @account.blank?
  		flash[:error] = "This area is not available for <strong>Unauthorized Students.</strong>"
  		self.resource = ""
  		render :new and return
  	end
  	super
  end

  # DELETE /resource/sign_out
  def destroy
    resource = current_student
    sign_out(resource_name)
    flash[:notice] = "Logged out successfully"
    redirect_to students_login_url(subdomain: resource.account.subdomain)
  end

  def login_after_confirmation
    login = params[:student_login]
    @student = Student.find_by_username login
    sign_in(@student.account.resource_type.downcase!, @student)
    redirect_to student_authenticated_root_path(subdomain: @student.account.subdomain)
    flash[:notice] = "Signed in successfully"
  end
end