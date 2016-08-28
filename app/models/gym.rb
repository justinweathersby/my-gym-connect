class Gym < ActiveRecord::Base
  resourcify
  
  belongs_to :user
  has_many :users

  validates :user_id, presence: true

end
