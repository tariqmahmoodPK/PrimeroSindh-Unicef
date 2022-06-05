if @cases.empty?
  json.data do
    json.set!("stats", {})
  end
else
  json.data do
    @cases.each do |key, value|
      if key.to_s.eql?("permission")
        json.set!(key, value)
      else
        json.stats do 
          concerns = {}
          value.each do |concern_key, concern_value|
            concern_key = Lookup.protection_concerns_values.find{|data| data["id"] == concern_key.to_s}["display_text"]["en"]
            concerns[concern_key] = concern_value
            json.set!(key, concerns)
          end
        end
      end
    end
  end
end
