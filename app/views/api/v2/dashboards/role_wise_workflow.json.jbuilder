json.data do
  @cases.each do |key, value|
    json.set!(key, value)
  end
end
