json.inbox do
  # json.array! @inbox do |message|
  #   json.from_id message.sender_id
  #   json.from User.find(message.sender_id).name
  #   json.body message.body
  #   json.created_at message.created_at
  # end
  json.array! @inbox
end

json.outbox do
  json.array! @outbox
  # json.array! @outbox do |message|
  #   json.to_id message.user_id
  #   json.to User.find(message.user_id).name
  #   json.body message.body
  #   json.created_at message.created_at
  # end
end

json.conversations do
  json.array! @conversations do |convo|
    json.array! convo do |msg|
      unless msg.is_a?(Array)
        json.name User.find(msg).name
        json.id msg
      else
        json.array! msg do |s|
          json.from User.find(s.sender_id).name
          json.from_id s.sender_id
          json.to User.find(s.user_id).name
          json.to_id s.user_id
          json.body s.body
          json.created_at s.created_at
        end
      end
    end
  end
end
