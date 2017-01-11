class Gym < ActiveRecord::Base
  resourcify

  belongs_to :user
  has_many :users
  has_many :push_notifications

  validates :user_id, presence: true
  validates :name, presence: true
  validates :contact_email, presence: true

  after_create :generate_access_code

  has_attached_file :image, styles: { medium: "500x500>", thumb: "100x100>" }, s3_protocol: :https
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  attr_writer :remove_image
  before_validation { self.image.clear if self.remove_image == '1' }

  def remove_image
    @remove_image || false
  end

  def generate_access_code
    loop do
      self.access_code = Devise.friendly_token(length = 10);
      break self.access_code unless Gym.where(access_code: self.access_code).first
    end
  end
end
