class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :gyms, dependent: :destroy
  has_many :conversations, dependent: :destroy
  belongs_to :gym
  # serialize :hours_in_gym, Array

  after_create :generate_auth_token

  ROLES = %i[admin gymManager banned]
  WORKOUTLEVELS = %i[beginner intermediate expert]
  GENDERS = %i[male female]
  WORKOUTTIMES = %i[morning afternoon night all]
  GENDERMATCH = %i[male female both]

  has_attached_file :image, styles: { medium: "700x700>", thumb: "150x150>" }, s3_protocol: :https,
                    :default_url => "https://s3.amazonaws.com/my-gym-connect-staging/users/images/missing.jpeg"
  has_attached_file :second_image, styles: { medium: "700x700>", thumb: "150x150>" }, s3_protocol: :https,
                    :default_url => "https://s3.amazonaws.com/my-gym-connect-staging/users/images/missing.jpeg"
  has_attached_file :third_image, styles: { medium: "700x700>", thumb: "150x150>" }, s3_protocol: :https,
                    :default_url => "https://s3.amazonaws.com/my-gym-connect-staging/users/images/missing.jpeg"
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_attachment_content_type :second_image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_attachment_content_type :third_image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  attr_writer :remove_image
  before_validation { self.image.clear if self.remove_image == '1' }

  attr_writer :remove_second_image
  before_validation { self.second_image.clear if self.remove_second_image == '1' }

  attr_writer :remove_third_image
  before_validation { self.third_image.clear if self.remove_third_image == '1' }

  attr_accessor :gym_name, :gym_location, :gym_phone

  def remove_image
    @remove_image || false
  end

  def remove_second_image
    @remove_second_image || false
  end

  def remove_third_image
    @remove_third_image || false
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
