class GymsController < InheritedResources::Base
  load_and_authorize_resource
  before_action :find_user, except: [:show, :subscription]
  before_action :authenticate_user!
  respond_to :html, :json
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

  def subscription
    @gym = Gym.find(params[:gym_id])
    @amount = params[:centAmount].try(:to_i)
    @public_token  = params[:public_token]
    @account_id = params[:account_id]

    user = Plaid::User.exchange_token(@public_token, @account_id)
    bank_account_token = user.stripe_bank_account_token

    if current_user.stripeid == nil
      customer = Stripe::Customer.create(
        :email => current_user.email,
        :source => bank_account_token
      )
      current_user.stripeid = customer.id
    else
      customer = Stripe::Customer.retrieve(current_user.stripeid)
      customer.source = bank_account_token
      customer.save
    end
    stripe_subscription = customer.subscriptions.create(:plan => 1, :metadata => {:gym => @gym.name})

    redirect_to user_gyms_path(current_user)

  rescue Stripe::CardError => e
    Rails.logger.error("Stripe::CardError: #{e.message}")
    render json: {error: e.message}.to_json, status: 400
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error("Stripe::InvalidRequestError: #{e.message}")
    render json: {error: e.message}.to_json, status: 400
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("ActiveRecord::RecordNotFound: #{e.message}")
    render json: {error: e.message}.to_json, status: 400
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
