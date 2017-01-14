class Message < ActiveRecord::Base
 belongs_to :conversation
 belongs_to :user
 after_create :upload_notification_to_ionic

 validates_presence_of :body
 # , :conversation_id, :user_id

 def message_time
  created_at.strftime("%m/%d/%y at %l:%M %p")
 end

 private
   def upload_notification_to_ionic
     puts "UPLOADING USER MESSAGE NOTIFICATION"
     token = nil;
     conversation = self.conversation
     if self.user_id == conversation.sender_id
       token = User.find(conversation.recipient_id).device_token
     else
       token = User.find(conversation.sender_id).device_token
     end

     unless token.nil?
       params = {
         "tokens" => token,
         "profile" => "production",
         "notification":{
           "message": self.body,
           "payload": {
             "user_message": "1",
             "conversation_id": conversation.id
           },
           "android":{
             "title": "My Gym Connect",
             "badge": "1"
           },
            "ios": {
                 "title": "My Gym Connect",
                 "badge": "1"
               }
         }
       }

       uri = URI.parse('https://api.ionic.io/push/notifications')
       https = Net::HTTP.new(uri.host,uri.port)
       https.use_ssl = true
       req = Net::HTTP::Post.new(uri.path)
       req['Authorization'] = ENV['IONIC_API_TOKEN']
       req['Content-Type'] = 'application/json'
       req.body = params.to_json
       res = https.request(req)
       puts res.body
     end
   end
end
