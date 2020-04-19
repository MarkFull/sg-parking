require 'json'

payload = JSON.parse(File.read('firebase/public/carparks.json'))

payload['features'].each do |record|
    next unless record['properties']['free_parking'].nil?
    rate = record['properties']['WeekDays_Rate_1']
    if rate === "Free daily"
        record['properties']['free_parking'] = "daily"
    elsif rate =~ /free/i || record['properties']['Saturday_Rate']  =~ /free/i || record['properties']['Sunday_PublicHoliday_Rate']  =~ /free/i
        record['properties']['free_parking'] = "partially"
    end
end

puts JSON.pretty_generate({ type: 'FeatureCollection', features: payload['features'] });