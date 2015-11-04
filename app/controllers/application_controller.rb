class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :resource_signed_in?

  include ActionView::Helpers::TagHelper
  include ActionView::Context
  
  add_breadcrumb "Dashboard"
  before_action :set_account
  
  def resource_signed_in?
  	if current_admin then return true end
  end

  def set_account
    @account = Account.find_by(subdomain: request.subdomain)
  end
end
