class PushNotificationsController < ApplicationController
  # load_and_authorize_resource
  before_action :authenticate_user!
  before_action :set_push_notification, only: [:destroy]

  def index
    @push_notifications= PushNotification.all.paginate(:page => params[:page])
  end

  def show
  end

  def new
    @push_notification = PushNotification.new
    @gym = Gym.find(params[:gym_id])
    @gym_users = @gym.users
    @customers = User.where.not('device_token' => nil)
  end

  def edit
  end

  def create
    @push_notification = PushNotification.new(push_notification_params)
    @gym = Gym.find(@push_notification.gym_id)
    @gym_users = @gym.users
    @push_notification.user_id = current_user.id
    @push_notification.sent_to = params[:tokens]
    @push_notification.sent_to.each do |t|
      device_token = User.find(t).device_token
      @push_notification.tokens.push(device_token) unless device_token.nil?
    end

    if @push_notification.save
      redirect_to url_for([current_user, @gym]), notice: 'Push Notification was successfully created.'
    else
      render :action => 'new',:gym_id => @gym.id
    end
  end

  def destroy
    @push_notification.destroy
    respond_to do |format|
      format.html { redirect_to push_notifications_path, notice: 'Push Notification was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_push_notification
      @push_notification = PushNotification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def push_notification_params
      params.fetch(:push_notification, {}).permit(:message, :sent_to, :user_id, :gym_id, tokens:[])
    end
end
