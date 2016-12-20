# json.conversations do
#   json.array! @conversations do |convo|
#     json.
#     # json.sender_name User.find(convo.sender_id).name
#     # json.sender_id = convo.sender_id
#     # json.recipient_name User.find(recipient_id).name
#     # json.recipient_id convo.recipient_id
#     # json.last_message convo.messages.last
#   end
# end

json.conversations @conversations do |convo|
      json.conversation_id convo.id
      json.sender_name convo.matched_name(current_user)
      json.sender_id convo.matched_id(current_user)
      json.sender_image convo.matched_image(current_user)
      json.last_message do
        json.body convo.messages.last.body
        json.sender_name User.find(convo.messages.last.user_id).name
        json.created_at convo.format_last_message_date
      end

end
