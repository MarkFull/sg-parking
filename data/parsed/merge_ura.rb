require 'json'

carparkSchedulesByPpCode = {}

payload = JSON.parse(File.read('carparks.json'))

newFeatures = payload['features'].select do |feature|
    ppCode = feature["properties"]["ppCode"]
    unless ppCode.nil?
        unless carparkSchedulesByPpCode[ppCode].nil?
            carparkSchedulesByPpCode[ppCode] << feature["properties"]
            false
        else
            feature["properties"] = {
                schedules: [feature["properties"]],
                geometries: feature["properties"]["geometries"],
                ppName: feature["properties"]["ppName"],
                ppCode: feature["properties"]["ppCode"],
                parkingSystem: feature["properties"]["parkingSystem"],
            }
            carparkSchedulesByPpCode[ppCode] = feature["properties"][:schedules]
            true
        end
    else
        true
    end
end;

puts JSON.generate({ type: 'FeatureCollection', features: newFeatures });