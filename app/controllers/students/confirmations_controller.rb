module Students
  class ConfirmationsController < DeviseController
    # GET /resource/confirmation?confirmation_token=abcdef
    def show
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])
      yield resource if block_given?

      if resource.errors.empty?
        # set_flash_message(:notice, :confirmed) if is_flashing_format?
        cookies[:confirm_notice] = {
          value: "Thank you for confirming your account. Your account has been confirmed on #{resource.confirmed_at.strftime('%Y-%B-%d')} at #{resource.confirmed_at.strftime('%H:%M:%S')}. You will recieve an email shortly with your credentials.",
          expires: Time.now + 30.seconds,
          domain: request.domain
        }

        StudentMailer.account_access(resource).deliver!
        respond_with_navigational(resource){ redirect_to root_path }
      else
        respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
      end
    end
  end
end