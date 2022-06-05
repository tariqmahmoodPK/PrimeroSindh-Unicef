json.data do
  @cases.each do |key, value|
    key == "permission" ? json.set!(key, value) : json.set!(key[0...-8].titleize, value)
  end
end
