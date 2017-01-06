json.(@user, :id, :email, :name, :role, :workout_time, :workout_level, :gender, :gender_match, :description, :created_at, :device_token, :device_type)
json.image_url @user.image.url(:medium)
json.second_image_url @user.second_image.url(:medium) if @user.second_image?
json.third_image_url @user.third_image.url(:medium) if @user.third_image?
json.gym Gym.find(@user.gym_id).name
