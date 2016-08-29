class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :gyms, dependent: :destroy
  belongs_to :gym

  ROLES = %i[admin gymManager banned]

  has_attached_file :image, styles: { medium: "500x500>", thumb: "100x100>" }
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  attr_writer :remove_image
  before_validation { self.image.clear if self.remove_image == '1' }

  def remove_image
    @remove_image || false
  end

  def role?(r)
     role.include? r.to_s
  end
end
