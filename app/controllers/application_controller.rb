class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :resource_signed_in?

  include ActionView::Helpers::TagHelper
  include ActionView::Context

  layout :layout_by_resource

  # include DefaultUrlOptions
  helper_method :set_account, :current_resource, :current_resource_name

  add_breadcrumb "Dashboard"
  
  before_action :set_account, :require_account!, :make_action_mailer_use_request_host_and_protocol
  before_action :configure_permitted_parameters, :devise_breadcrumbs, if: :devise_controller?

  devise_group :user, contains: [:student, :teacher, :admin]

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

  def devise_breadcrumbs
    if resource_class == Student
      add_breadcrumb "Admissions-#{params[:batch_name]}" if params[:batch_name].present?
    elsif resource_class == Teacher
      add_breadcrumb "Teachers"
    end
  end
  
  def layout_by_resource
    if request.subdomain.blank?
      "application"
    else
      if @account.present?
        "resource"
      else
        "page_not_found"
      end
    end
  end

  def current_resource_name
    @account["resource_type"].underscore
  end

  def resource_signed_in?
  	send("#{current_resource_name}_signed_in?")
  end

  def set_account
    account = $redis.get("account_#{request.subdomain}")
    if account.nil?
      account = Account.find_by(subdomain: request.subdomain).as_json(include: :resource).to_json
      $redis.set("account_#{request.subdomain}", account)
    end
    @account = JSON.load(account)
  end
  
  def require_account!
    if request.subdomain.present?
      unless @account.blank?
        case @account["resource_type"]
        when :student.to_s.capitalize
          unless current_controller?("students/sessions")
            student_authentication
          end
        when :admin.to_s.capitalize
          unless current_controller?("admins/sessions")
            admin_authentication
          end
        when :teacher.to_s.capitalize
          unless current_controller?("teachers/sessions")
            teacher_authentication
          end
        end
      end
    end
  end

  %w(Admin Student Teacher).each do |k|
    define_method "#{k.underscore}_resource" do
      @account["resource_type"] == k.constantize.to_s
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
          # resource_name = students_domain || k.underscore 
          redirect_to send("#{k.underscore.pluralize}_login_path", subdomain: @account["subdomain"])
        else
          send("authenticate_#{k.underscore}!")
        end
      end
    end
  end

  def set_custom_flash_message(name, msg, expiry = (Time.now + 15.seconds))
    cookies[name.to_sym] = {
      value: msg.to_s,
      expires: expiry,
      domain: request.domain
    }
  end

  def authenticated_root subdomain
    if admin_resource
      admin_authenticated_root_path(subdomain: subdomain)
    elsif student_resource
      student_authenticated_root_path(subdomain: subdomain)
    elsif teacher_resource
      teacher_authenticated_root_path(subdomain: subdomain)
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

  # Profile params
  def update_account_parameters_sanitizer(resource)
    case resource
    when "student".to_sym
      params.require(:student).permit(:email, :username,
                                      :first_name, :last_name, :date_of_birth, :roll_number, :address, :phone, 
                                      :section_id, :batch_id, :semester_id, :gender, 
                                      :avatar_attributes => [ :id, :image ], 
                                      :account_attributes => [:id, :subdomain])
    when "teacher".to_sym
      params.require(:teacher).permit(:email, :username,
                                      :first_name, :last_name, :address, 
                                      :avatar_attributes => [ :id, :image ])
    end 
  end

  def current_resource
    current_admin || current_student || current_teacher || current_parent
  end
  
  private

  def make_action_mailer_use_request_host_and_protocol
    ActionMailer::Base.default_url_options[:protocol] = request.protocol
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  protected

  # Devise account create params
  def configure_permitted_parameters
    if resource_class == Teacher
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email,:first_name, :last_name, :gender, :date_of_birth,
                                                              :joining_date, :qualification, :past_experience,
                                                              :phone, :skills) }
    elsif resource_class == Student
      devise_parameter_sanitizer.for(:student) {|u| u.permit(:email, :password, :password_confirmation, :username,
                                                            :first_name, :last_name, :date_of_birth, :roll_number, :address, :phone, 
                                                            :section_id, :batch_id, :semester_id, :gender) }
    end
  end

end
