class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :resource_signed_in?

  include ActionView::Helpers::TagHelper
  include ActionView::Context

  layout :layout_by_resource

  # include DefaultUrlOptions
  helper_method :set_account

  add_breadcrumb "Dashboard"
  
  before_action :set_account
  before_action :require_account!
  

  def layout_by_resource
    if request.subdomain.blank?
      "application"
    else
      if @account.resource_type == :admin.to_s.capitalize
        "admin_layout"
      elsif @account.resource_type == :student.to_s.capitalize
        "student_layout"
      end
    end
  end

  def resource_signed_in?
  	if current_admin then return true end
  end

  def set_account
    @account = Account.find_by(subdomain: request.subdomain)
  end

  # def after_sign_out_path_for(resource_or_scope)
  #   root_url(subdomain: nil) if resource_or_scope == :admin
  # end
  
  def require_account!
    if request.subdomain.present?
      if @account.blank?
        cookies[:nil_account] = {
          :value => "This area is restricted for <strong>Unauthorized Users</strong>",
          :domain => request.domain,
          :expires => Time.now + 10.seconds
        }
        redirect_to root_url(subdomain: nil)

      else
        case @account.resource_type
        when :student.to_s.capitalize
          redirect_to students_login_url(subdomain: @account.subdomain) if !current_student
        when :admin.to_s.capitalize
          redirect_to admin_login_path(subdomain: @account.subdomain) if !current_admin
        end
      end
    end
  end

  def current_controller?(names)
    if params[:controller] == names
      true
    end
  end

  def current_action?(names)
    if params[:action] == names
      true
    end
  end
end
