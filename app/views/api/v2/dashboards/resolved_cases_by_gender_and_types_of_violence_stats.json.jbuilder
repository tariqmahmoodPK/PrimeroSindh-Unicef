json.data do
  @stats.each do |key, value|
    if key.to_s.eql?("permission")
      json.set!(key, value)
    else
      concerns = {}
      value.each do |key1, value2|
        key1 = Lookup.protection_concerns_values.find{|data| data["id"] == key1.to_s}["display_text"]["en"]
        concerns[key1] = value2
      end
      json.set!(key, concerns)
    end
  end
end