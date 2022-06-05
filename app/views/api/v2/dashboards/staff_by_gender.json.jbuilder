if @stats.class.eql?(Hash)
  json.set!(@stats.keys[0], @stats.values[0])
else
  json.data @stats
  json.labels ["Male", "Female", "Transgender"]
end
