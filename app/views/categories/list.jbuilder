json.dos  do
  json.array! @dos do |cat|
    json.id  cat.id
    json.name cat.name
  end
end

json.donts  do
  json.array! @donts do |cat|
    json.id  cat.id
    json.name cat.name
  end
end
