json.data do
  @statuses.each do |key, value|
    json.set!(key, value)
  end
end
