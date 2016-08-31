class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :gyms, dependent: :destroy
  belongs_to :gym

  serialize :hours_in_gym, Array

  ROLES = %i[admin gymManager banned]
  WORKOUTLEVELS = %i[beginner intermediate expert]
  GENDERS = %i[male female]

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

  # def calc_datetime_from_hours(hours)
    # Find a day thats a sunday in time and starts at 12:00am
    # start_date = DateTime.new(2001,2,3,4,5,6)
    # date = start_date + hours

    # adjusted_datetime = (datetime_from_form.to_time - n.hours).to_datetime
    # adjusted = time_from_form.advance(:hours => -n)

    # return format date to be only day of week and time
  # end
end
