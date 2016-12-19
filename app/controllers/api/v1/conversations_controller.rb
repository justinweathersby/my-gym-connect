class Api::V1::ConversationsController < Api::ApiController
 load_and_authorize_resource
 before_action :authenticate_with_token!

def index
 @conversations = Conversation.where("sender_id = ? OR recipient_id = ?", current_user.id, current_user.id)
end

def create
  # ---The between method checks to see if a conversation between these 2 users
  # ---exists…only if one does not already exist is the conversation created.
  if Conversation.between(current_user.id ,params[:recipient_id])
    .present?
    @conversation = Conversation.between(current_user.id,
     params[:recipient_id]).first
 else
    @conversation = Conversation.create(conversation_params)
 end
end

private
 def conversation_params
  params.permit(:sender_id, :recipient_id)
 end

end
