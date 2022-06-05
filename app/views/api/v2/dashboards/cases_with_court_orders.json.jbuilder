if @cases.class.eql?(Hash)
  json.set!(@cases.keys[0], @cases.values[0])
else
  json.data @cases
  json.labels ["Supervision", "Permanent Custody and Placement", "Interim Custody and Placement", "Seek and Find"]
end
