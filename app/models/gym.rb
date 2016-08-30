class Gym < ActiveRecord::Base
  resourcify

  belongs_to :user
  has_many :users

  validates :user_id, presence: true

  has_attached_file :image, styles: { medium: "500x500>", thumb: "100x100>" }
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  attr_writer :remove_image
  before_validation { self.image.clear if self.remove_image == '1' }

  def remove_image
    @remove_image || false
  end
end
