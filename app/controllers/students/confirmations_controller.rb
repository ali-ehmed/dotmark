module Students
  class ConfirmationsController < DeviseController
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

        StudentMailer.account_access(resource).deliver!
        respond_with_navigational(resource){ redirect_to root_url(subdomain: nil) }
      else
        respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
      end
    end
  end
end