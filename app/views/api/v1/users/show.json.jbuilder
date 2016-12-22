json.(@user, :id, :email, :name, :role, :workout_time, :workout_level, :gender, :gender_match, :created_at)
json.image_url @user.image.url(:medium) if @user.image?
json.gym Gym.find(@user.gym_id).name
