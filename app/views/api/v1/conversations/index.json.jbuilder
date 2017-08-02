json.conversations @conversations do |convo|
      json.conversation_id convo.id
      json.sender_name convo.matched_name(current_user)
      json.sender_id convo.matched_id(current_user)
      json.sender_image convo.matched_image(current_user)
      json.last_message do
        json.body convo.messages.last.body
        json.sender_name User.find(convo.messages.last.user_id).name
        json.created_at convo.created_at
      end
end
