class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @gym = @user.gym if @user.gym_id.present?
  end
end
