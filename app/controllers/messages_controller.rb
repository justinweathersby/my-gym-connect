class MessagesController < InheritedResources::Base
  def index
  end

  def show
  end
  
  private

    def message_params
      params.require(:message).permit(:user_id, :body)
    end
end
