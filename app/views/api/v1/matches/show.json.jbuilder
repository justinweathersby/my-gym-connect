json.array! @matches do |match|

  json.id match.id
  json.name match.name
  json.email match.email
  json.hours_in_gym match.hours_in_gym
  json.image_url match.image.url(:medium)
end
