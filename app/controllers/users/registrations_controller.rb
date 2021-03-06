class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action { flash.clear }

  def after_update_path_for(resource)
    user = resource
    determine_redirect_path(user)
  end

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super do
      if resource.role == "gymManager"
        resource.add_role :gymManager
        resource.save
      end

    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # Determines route after sign up for different roles
  def determine_redirect_path user
    if user.has_role? :gymManager
      user_gyms_path(user)
    else
      user_path(user)
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :image, :remove_image, :name, :workout_level, :gender, :gender_match, :gym_id, :workout_time, :description, :stripeid, :hours_in_gym => []])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:role, :image, :remove_image, :name, :workout_level, :gender, :gender_match, :gym_id, :workout_time, :description, :stripeid, :hours_in_gym => []])
  end


  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
