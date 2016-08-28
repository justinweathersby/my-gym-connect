class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :gyms, dependent: :destroy
  belongs_to :gym

  ROLES = %i[admin gymManager banned]

  def role?(r)
     role.include? r.to_s
  end
end
