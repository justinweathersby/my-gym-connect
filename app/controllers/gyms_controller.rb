require 'plaid'

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
    @gym_users_count = 0
    @monthly_popularity = 0
    @conversation_count = 0

    @gyms.each do |g|
      @gym_users = g.users
      @gym_users_count += @gym_users.count
      @conversation_count += g.conversation_count
      @monthly_popularity += g.users.where('created_at > ?', 30.days.ago).count
    end
    if @gym_users_count > 0
      @monthly_popularity = ((@monthly_popularity.to_f / @gym_users_count) * 100).round()
    end
  end

  def create
    @gym = current_user.gyms.build(gym_params)
    @gym.generate_access_code
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
    @gym_users = @gym.users
    @gym_users_pages = @gym_users.paginate(:page => params[:users_page], :per_page => 5)
    @gym_push_notifications = @gym.push_notifications.paginate(:page => params[:notifications_page], :per_page => 5)
    if @gym_users.count > 0
      @monthly_popularity = (@gym_users.where('created_at > ? ', 30.days.ago).count.to_f / @gym_users.count).round()
    else
      @monthly_popularity = 0
    end
  end

  def subscription
    @gym = Gym.find(params[:gym_id])
    public_token  = params[:public_token]
    account_id = params[:account_id]
    plan_id = params[:plan_id]

    client = Plaid::Client.new(env: :sandbox,
                             client_id: ENV['PLAID_CLIENT_ID'],
                             secret: ENV['PLAID_SECRET'],
                             public_key: ENV['PLAID_PUBLIC_KEY'])

    if account_id.present?
      exchange_token_response = client.item.public_token.exchange(public_token)
      access_token = exchange_token_response['access_token']

      stripe_response = client.processor.stripe.bank_account_token.create(access_token, account_id)
      bank_account_token = stripe_response['stripe_bank_account_token']
    else
      bank_account_token = public_token
    end

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

    # -- Add an initial charge for first time signup
    Stripe::InvoiceItem.create(
        :customer => customer,
        :amount => ENV['GYM_SETUP_FEE'],
        :currency => "usd",
        :description => "One-time Gym setup fee for " + @gym.name
    )

    stripe_subscription = customer.subscriptions.create(:plan => plan_id, :metadata => {:gym => @gym.name})

    @gym.active = true
    @gym.subscription_id = stripe_subscription.id
    @gym.save

    flash[:notice] = @gym.name + ' is now active! Thank you for your subscription'
    flash.keep(:notice)
    render js: "window.location = '#{user_gyms_url(current_user)}'"

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
      params.require(:gym).permit(:name, :image, :remove_image, :contact_email, :location, :phone, :hours_of_operation, :active, :subscription_id, :plan_id)
    end

    def find_user
      @user = User.find(params[:user_id])
    end
end
