json.data do
  if @stats.empty?
    json.set!("stats", {})
  else
    @stats.each do |key, value|
      if key.to_s.eql?("permission")
        json.set!(key, value)
      else
        json.stats do
          json.set!(key, value)
        end
      end
    end
  end
end
