class UserParameterSanitizer < Devise::ParameterSanitizer
	def initialize(*)
    # super
    devise_parameter_sanitizer.for(:sign_up)
  end
end