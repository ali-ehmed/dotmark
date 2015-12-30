module Resource
  class ConfirmationsController < DeviseController
    def new
      self.resource = resource_class.new
    end
    # GET /resource/confirmation?confirmation_token=abcdef
    def show
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])
      yield resource if block_given?
      if resource.errors.empty?
        # set_flash_message(:notice, :confirmed) if is_flashing_format?
        cookies[:confirm_notice] = {
          value: "Thank you for confirming your account. Your account has been confirmed on <strong>#{resource.confirmed_at.strftime('%d-%B-%Y')}</strong> at <strong>#{resource.confirmed_at.strftime('%H:%M:%S')}</strong>. You will recieve an email shortly with your credentials.",
          expires: Time.now + 15.seconds,
          domain: request.domain
        }

        StudentMailer.account_access(resource).deliver_now!
        respond_with_navigational(resource){ redirect_to root_url(subdomain: nil) }
      else
        @confirmation_errors = resource.errors
        @new_confirmation_url = send("#{resource.class.to_s.underscore}_confirmation_path", resource_name)
        respond_with_navigational(@confirmation_errors, status: :unprocessable_entity) do
          redirect_to confirmation_expired_url(subdomain: resource.account.subdomain, :confirmation_token => params["confirmation_token"])
        end
      end
    end
  end
end