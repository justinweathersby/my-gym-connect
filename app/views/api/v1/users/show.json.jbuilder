json.(@user, :id, :email, :name, :role, :hours_in_gym, :workout_level, :workout_level, :gender, :created_at)
json.image_url @user.image.url(:medium) if @user.image?
json.gym Gym.find(@user.gym_id).name
