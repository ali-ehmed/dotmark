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
  before_action :parameters_sanitizer, if: :devise_controller?

  def pjax_layout
    'pjax'
  end

  class Layout
    def self.admin_dashboard
      "admins/dashboard"
    end

    def self.student_dashboard
      "students/dashboard"
    end
  end
  
  def layout_by_resource
    if request.subdomain.blank?
      "application"
    else
      if @account.present?
        if @account.resource_type == :admin.to_s.capitalize
          "admin_layout"
        elsif @account.resource_type == :student.to_s.capitalize
          "student_layout"
        end
      else
        "page_not_found"
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
    # if resource_signed_in?
    #   cookies[:signed_in_resource_domain] = {
    #     :value => if current_admin then current_admin.account.subdomain elsif current_student then current_student.account.subdomain end,
    #     :domain => request.domain,
    #     :expires => Time.now + 20.seconds
    #   }
    # end

    if request.subdomain.present?
      unless @account.blank?
        # cookies[:confirm_notice] = {
        #   value: "This area is restricted for <strong>Unauthorized Users</strong>",
        #   expires: Time.now + 10.seconds,
        #   domain: request.domain
        # }
        # if cookies[:signed_in_resource_domain].present? and cookies[:signed_in_resource_domain] == "admin"
        #   redirect_to admin_authenticated_root_url(subdomain: cookies[:signed_in_resource_domain])
        # elsif cookies[:signed_in_resource_domain].present? and cookies[:signed_in_resource_domain] == Student.find_by_username(cookies[:signed_in_resource_domain]).username
        #   redirect_to student_authenticated_root_url(subdomain: cookies[:signed_in_resource_domain])
        # else
          # redirect_to root_url(subdomain: nil)
        # end
      # else
        case @account.resource_type
        when :student.to_s.capitalize
          unless current_controller?("students/sessions")
            student_authentication
          end
        when :admin.to_s.capitalize
          unless current_controller?("admins/sessions")
            admin_authentication
          end
        end
      end
    end
  end


  %w(Admin Student Teacher).each do |k|
    define_method "#{k.underscore}_resource" do
      @account.resource_type == k.constantize.to_s
    end

    define_method "#{k.underscore}_authentication" do
      if !send("#{k.underscore}_signed_in?")
        cookies[:login_path] = {
          value: k.underscore,
          expires: Time.now + 3.seconds,
          domain: request.domain
        }

        login_path = cookies[:login_path]
        if login_path and current_controller?("landings")
          cookies[:login_path] = nil

          students_domain = k.underscore.pluralize if k.constantize == Student
          resource_name = students_domain || k.underscore 
          redirect_to send("#{resource_name}_login_path", subdomain: @account.subdomain)
        else
          send("authenticate_#{k.underscore}!")
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

  protected

  def parameters_sanitizer
    if resource_class == Teacher
      devise_parameter_sanitizer.for(:teacher) { |u| u.permit(:email,:first_name, :last_name, :gender, :date_of_birth,
                                                              :joining_date, :qualification, :past_experience,
                                                              :phone, :skills) }
    elsif resource_class == Student
      devise_parameter_sanitizer.for(:student) {|u| u.permit(:email, :password, :password_confirmation, :username,
                                                            :first_name, :last_name, :date_of_birth, :roll_number, :address, :phone, 
                                                            :section_id, :batch_id, :semester_id, :gender) }
    end
  end
end
