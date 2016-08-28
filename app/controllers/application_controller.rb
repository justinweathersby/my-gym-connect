class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_active_admin_user!
   authenticate_user!
   unless current_user.role?(:admin)
      flash[:alert] = "You are not authorized to access this resource!"
      redirect_to root_path
   end
 end

 def authenticate_gym_manager!
   authenticate_user!
   unless current_user.role(:gymManager)
     flash[:alert] = "You are not authorized to access this resource!"
     redirect_to root_path
   end
 end

 rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

 def after_sign_in_path_for(resource)
   determine_redirect_path(resource)
 end

 protected

 def determine_redirect_path(user)
   if user.has_role? :admin
     admin_root_path
   elsif user.has_role? :gymManager
     user_gyms_path(user)
   else
     flash[:alert] = "Sorry but you have logged in as a normal user and we dont have a dashboard for you yet... Trying to test the site? Sign up as a gym owner. Thanks for the cooperation. Users, keep waiting for the app."
     root_path
   end
 end
end
