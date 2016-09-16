class Message < ActiveRecord::Base
  validates :user_id, :presence => true
  validates :sender_id, :presence => true
end
