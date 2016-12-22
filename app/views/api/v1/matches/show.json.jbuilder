json.array! @matches do |match|

  json.id match.id
  json.name match.name
  json.email match.email
  json.gender match.gender
  json.workout_time match.workout_time
  json.workout_level match.workout_level
  json.image_url match.image.url(:medium)
end
