json.array! @matches do |match|
  json.id match.id
  json.name match.name
  json.email match.email
  json.gender match.gender
  json.workout_time match.workout_time
  json.workout_level match.workout_level
  json.description match.description
  json.days_per_week match.days_per_week
  json.cardio_per_week match.cardio_per_week
  json.workout_preference match.workout_preference
  json.attend_classes match.attend_classes
  json.image_url match.image.url(:medium)
  json.second_image_url match.second_image.url(:medium) if match.second_image?
  json.third_image_url match.third_image.url(:medium) if match.third_image?
end
