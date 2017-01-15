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
     user_id = nil;
     username = "";
     conversation = self.conversation

     if self.user_id == conversation.sender_id
       user_id = conversation.recipient_id
     else
       user_id = conversation.sender_id
     end

     user = User.find(user_id)
     token = user.device_token
     message_text = user.name + ": " + self.body

     unless token.nil?
       params = {
         "tokens" => token,
         "profile" => "dev",
         "notification":{
           "message": message_text,
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
