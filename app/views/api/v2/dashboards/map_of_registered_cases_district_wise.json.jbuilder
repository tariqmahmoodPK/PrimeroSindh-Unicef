json.data do
  if @stats.empty?
    json.set!("stats", [])
  else
    if @stats.class.eql?(Hash)
      json.set!(@stats.keys[0], @stats.values[0])
    else
      json.stats @stats
    end
  end
end
