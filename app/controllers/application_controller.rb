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
  
  before_action :set_account, :require_account!, :make_action_mailer_use_request_host_and_protocol
  

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
  	if current_admin or current_student then return true end
  end

  def set_account
    @account = Account.find_by(subdomain: request.subdomain)
  end

  # def after_sign_out_path_for(resource_or_scope)
  #   root_url(subdomain: nil) if resource_or_scope == :admin
  # end
  
  def require_account!
    if resource_signed_in?
      cookies[:signed_in_resource_domain] = {
        :value => if current_admin then current_admin.account.subdomain elsif current_student then current_student.account.subdomain end,
        :domain => request.domain,
        :expires => Time.now + 20.seconds
      }
    end

    if request.subdomain.present?
      if @account.blank?
        cookies[:confirm_notice] = {
          value: "This area is restricted for <strong>Unauthorized Users</strong>",
          expires: Time.now + 10.seconds,
          domain: request.domain
        }
        if cookies[:signed_in_resource_domain].present? and cookies[:signed_in_resource_domain] == "admin"
          redirect_to admin_authenticated_root_url(subdomain: cookies[:signed_in_resource_domain])
        elsif cookies[:signed_in_resource_domain].present? and cookies[:signed_in_resource_domain] == Student.find_by_username(cookies[:signed_in_resource_domain]).username
          redirect_to student_authenticated_root_url(subdomain: cookies[:signed_in_resource_domain])
        else
          redirect_to root_url(subdomain: nil)
        end
      else
        case @account.resource_type
        when :student.to_s.capitalize
          unless current_controller?("students/sessions")
            redirect_to students_login_url(subdomain: @account.subdomain) if !current_student
          end
        when :admin.to_s.capitalize
          unless current_controller?("admins/sessions")
            redirect_to admin_login_path(subdomain: @account.subdomain) if !current_admin
          end
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
  
  private

  def make_action_mailer_use_request_host_and_protocol
    ActionMailer::Base.default_url_options[:protocol] = request.protocol
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
end
