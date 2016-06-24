module Resources
  class ConfirmationsController < DeviseController
    def new
      self.resource = resource_class.new
    end

    def create
      self.resource = resource_class.send_confirmation_instructions(resource_params)
      yield resource if block_given?

      if successfully_sent?(resource)
        respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
      else
        # respond_with(resource)
        render "devise/confirmations/new", :confirmation_token => params["confirmation_token"]
      end
    end
    
    # GET /resource/confirmation?confirmation_token=abcdef
    def show
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])
      yield resource if block_given?
      if resource.errors.empty?
        # set_flash_message(:notice, :confirmed) if is_flashing_format?
        set_custom_flash_message(:confirm_notice, "Thank you for confirming your account. Your account has been confirmed on <strong>#{resource.confirmed_at.strftime('%d-%B-%Y')}</strong> at <strong>#{resource.confirmed_at.strftime('%H:%M:%S')}</strong>. You will recieve an email shortly with your credentials.")

        AccountMailer.account_access(resource).deliver_now!
        respond_with_navigational(resource){ redirect_to root_url(subdomain: nil) }
      else
        confirmation_resource = resource.class.to_s.underscore
        respond_with_navigational(resource.errors, status: :unprocessable_entity) do
          render "devise/confirmations/new", :confirmation_token => params["confirmation_token"]
        end
      end
    end
  end
end