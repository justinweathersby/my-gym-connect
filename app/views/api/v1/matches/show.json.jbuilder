json.array! @matches do |match|
  json.id match.id
  json.name match.name
  json.email match.email
  json.gender match.gender
  json.workout_time match.workout_time
  json.workout_level match.workout_level
  json.description match.description
  json.image_url match.image.url(:medium)
  json.second_image_url match.second_image.url(:medium)
  json.third_image_url match.third_image.url(:medium)
end
