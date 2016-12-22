class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :gyms, dependent: :destroy
  belongs_to :gym

  serialize :hours_in_gym, Array

  after_create :generate_auth_token

  ROLES = %i[admin gymManager banned]
  WORKOUTLEVELS = %i[beginner intermediate expert]
  GENDERS = %i[male female]
  WORKOUTTIMES = %i[morning afternoon night all]

  has_attached_file :image, styles: { medium: "500x500>", thumb: "100x100>" }, s3_protocol: :https
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  attr_writer :remove_image
  before_validation { self.image.clear if self.remove_image == '1' }

  def remove_image
    @remove_image || false
  end

  def role?(r)
     role.include? r.to_s
  end

  def generate_auth_token
    loop do
      self.auth_token = Devise.friendly_token
      break self.auth_token unless User.where(auth_token: self.auth_token).first
    end
  end
end
