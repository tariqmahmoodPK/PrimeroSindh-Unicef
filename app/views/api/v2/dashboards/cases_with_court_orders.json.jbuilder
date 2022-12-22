if @cases.class.eql?(Hash)
  json.set!(@cases.keys[0], @cases.values[0])
else
  json.data @cases
  json.labels ["Supervision", "Emergency custody order", "Non-Emergency Alternative Care Placement Order", "Seek and Find"]
end
