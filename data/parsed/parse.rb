# Usage:
# ruby fetch.rb > carparks.json

require 'json'
require 'svy21'
require 'csv'

payload = JSON.parse(File.read('data/raw/hdb.json'))
results = payload['records'].map do |record|
    lat, lng = SVY21.svy21_to_lat_lon(record['y_coord'].to_f, record['x_coord'].to_f)
    record.merge!({
        location: { latitude: lat, longitude: lng },
        source: 'HDB'
    })
    { type: 'Feature', geometry: { type: "Point", coordinates: [lng, lat] }, properties: record }
end

ura_payload = JSON.parse(File.read('data/raw/ura.json'))
results += ura_payload['Result'].map do |record|
    if record['geometries'].nil?
        resp = Net::HTTP.get('us1.locationiq.com', '/v1/search.php?key=6ee88794b1b61d&format=json&q='+
            URI::encode(record["ppName"] + ' SG'))
        resp_obj = JSON.parse(resp)
        if resp_obj[0].nil? || (resp_obj[0]["lat"].to_f > 2 && resp_obj[0]["lat"].to_f < 0)
            puts record["ppName"]
            puts resp_obj
            record["lat"] = gets.chomp.to_f
            record["lon"] = gets.chomp.to_f
            next { type: 'Feature', geometry: { type: "Point", coordinates: [record["lon"], record["lat"]] }, properties: record }
        else
            record["lat"] = resp_obj[0]["lat"].to_f
            record["lon"] = resp_obj[0]["lon"].to_f
            next { type: 'Feature', geometry: { type: "Point", coordinates: [record["lon"], record["lat"]] }, properties: record }
        end
    end
    coordinates = record['geometries'].map do |geometry|
        lat, lng = SVY21.svy21_to_lat_lon(*geometry['coordinates'].split(',').reverse().map(&:to_f))
        [lng, lat]
    end
    record.merge1({
        source: 'URA'
    })
    { type: 'Feature', geometry: { type: "LineString", coordinates: coordinates }, properties: record }
end

lta_payload = CSV.read("data/raw/CarParkRates.csv", headers: true)
lta_payload.each do |row| 
    next if row["lat"].to_f < 2 && row["lat"].to_f > 0
    puts row["CarPark"]
    row["lat"] = gets.chomp
    row["lon"] = gets.chomp
    # resp = Net::HTTP.get('us1.locationiq.com', '/v1/search.php?key=6ee88794b1b61d&format=json&q='+URI::encode(row["CarPark"] + ' Singapore'))
    # resp = Net::HTTP.get(URI('https://developers.onemap.sg/commonapi/search?returnGeom=Y&getAddrDetails=Y&pageNum=1&searchVal='+URI::encode(row["CarPark"])))
    # resp_obj = JSON.parse(resp)
    # if resp_obj[0].nil?
    #     puts row["CarPark"]
    #     next
    # else
    #     row["lat"] = resp_obj[0]["lat"]
    #     row["lon"] = resp_obj[0]["lon"]
    # end
end.length
# CSV.open("data/parsed/lta_with_lat_lng.csv", "wb") do |csv|
#     lta_payload.each do |row|
#         csv << row
#     end
# end

lta_payload.each do |record|
    lat = record["lat"].to_f
    lng = record["lon"].to_f
    record["source"] = "LTA"
    results << { type: 'Feature', geometry: { type: "Point", coordinates: [lng, lat] }, properties: record.to_h }
end

puts JSON.generate({ type: 'FeatureCollection', features: results });

# require "google/cloud/firestore"

# firestore = Google::Cloud::Firestore.new

# results.each_slice(500) do |batch_results|
#     firestore.batch do |b|
#         batch_results.each do |result|
#             b.set("carparks/#{result["car_park_no"]}", result)
#         end
#     end
# end