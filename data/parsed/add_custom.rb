require 'json'
require 'csv'

payload = JSON.parse(File.read('firebase/public/carparks.json'))

custom_rows = CSV.read("data/raw/custom.csv", headers: true)
custom_rows.each do |row|
    lat = row["coordinates"].split(',')[0].to_f
    lng = row["coordinates"].split(',')[1].to_f
    row["source"] = "custom"
    payload['features'] << { type: 'Feature', geometry: { type: "Point", coordinates: [lng, lat] }, properties: row.to_h }
end

puts JSON.pretty_generate({ type: 'FeatureCollection', features: payload['features'] });