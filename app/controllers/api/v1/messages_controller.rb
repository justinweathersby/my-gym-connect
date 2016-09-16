class Api::V1::MessagesController < Api::ApiController
  before_action :authenticate_with_token!

  def create
    @message = Message.new(message_params)
    @message.sender_id = current_user.id
    if  @message.save
      render :new, status: :ok, formats: [:json]
    else
      render json: @message.errors, status: :bad_request
    end
  end

  def index
    @inbox = Message.where(:user_id => current_user.id).order(created_at: :desc).group_by{|message| message.sender_id}
    @outbox = Message.where(:sender_id => current_user.id).order(created_at: :desc).group_by{|message| message.user_id}
    @conversations = @inbox.merge(@outbox){|key, first, second| first.is_a?(Array) && second.is_a?(Array) ? first | second : second }

    # @testCombine.each do |message|
    #   puts 'Message: ', message.inspect
    #   puts '\n\n'
    #   message[1].each do |row|
    #     puts 'Row: ', row
    #     puts '\n'
    #
    #   end
      # message.sort! { |a,b| a.created_at <=> b.created_at }
      # message.sort_by { |hsh| hsh[:created_at] }
    # end

  end

  def show
  end

  def destroy
  end

  private

    def message_params
      params.permit(:user_id, :body)
    end
end
