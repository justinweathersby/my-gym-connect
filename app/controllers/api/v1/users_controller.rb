class Api::V1::UsersController < Api::ApiController
  before_action :authenticate_with_token!, only: [:update, :show]
  respond_to :json

  def create
    @user = User.new(sign_up_params)
    if @user.valid?
      gym_access_code = params[:gym_code]
      gym = Gym.find_by_access_code(gym_access_code)
      if gym.present?
        @user.gym_id = gym.id
        # @user.generate_auth_token
        puts "Inside gym present true...user:", @user.inspect
        @user.save
        render json: {user: @user}, status: 200
      else
        # render json: {errors: "Gym Not Found"}, status: 422

        render json: {errors: {"Gym" => ["Not Found"]}}, status: 422
      end
    else
      render json: { errors: @user.errors}, status: :bad_request
    end
  end

  def show
    @user = current_user
  end

  def update
  	@user = current_user
  	if @user.update_attributes(update_params)
  		render :update, status: :ok, formats: [:json]
  	else
  		render json: {errors: @user.errors}, status: 422
  	end
  end

  # def reset_password
  #   @user = User.find_by_email(params[:user][:email])
  #   if @user.present?
  #     # @user.send_reset_password_instructions
  #     # render json: { "result" => "Email with reset instructions has been sent"}, status: :ok
  #   else
  #    render json: { "errors" => "Email not found"}, status: 422
  #   end
  # end

  private

  def sign_up_params
    params[:user].permit(:name, :email, :password, :password_confirmation, :device_token, :device_type, :gym_code)
    # params.permit(:first_name,:last_name,:company_name,:organization_name ,:officer_name,:email, :password, :password_confirmation)
  end

  def update_params
    params.permit(:id, :name, :password, :workout_level,
                  :image, :second_image, :third_image, :gender, :gender_match, :workout_time, :description,
                  :device_token, :device_type,
                  :days_per_week, :cardio_per_week,:workout_preference, :attend_classes,
                  hours_in_gym: [])
  end
end
