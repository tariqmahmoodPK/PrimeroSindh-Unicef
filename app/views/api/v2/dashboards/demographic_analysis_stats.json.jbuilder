if @stats.class.eql?(Hash)
  json.set!(@stats.keys[0], @stats.values[0])
else
  json.data @stats
  json.labels ["Minority Cases", "CwD Cases", "Cases with Social Protection Benif."]
end
