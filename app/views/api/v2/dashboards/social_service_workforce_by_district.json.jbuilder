json.data do
  @users.each do |key, value|
    json.set!(key, value)
  end
end
