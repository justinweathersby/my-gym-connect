class GymsController < InheritedResources::Base
  load_and_authorize_resource
  before_action :find_user, except: [:show]
  before_action :authenticate_user!
  # before_action :authenticate_admin!, except: [:show, :new, :create]
  # skip_before_action :authenticate_user!, only: [:new, :create]

  # def new
  # end

  def index
    @gyms = current_user.gyms
  end

  def create
    @gym = current_user.gyms.build(gym_params)
    if @gym.save
      flash[:success] = "Gym created!"
      redirect_to user_gym_path(@user,@gym)
    else
      flash[:success] = "Sorry Something Went Wrong!"
      redirect_to new_user_gym_path(@user)
    end
  end

  def show
    @gym = Gym.find(params[:id])
  end

  # def edit
  # end


  private

    def gym_params
      params.require(:gym).permit(:name, :image, :remove_image, :contact_email, :location, :phone, :hours_of_operation)
    end

    def find_user
      @user = User.find(params[:user_id])
    end
end
